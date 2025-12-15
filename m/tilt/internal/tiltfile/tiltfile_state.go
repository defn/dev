package tiltfile

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/looplab/tarjan"
	"go.starlark.net/starlark"
	"go.starlark.net/syntax"

	"github.com/defn/dev/m/tilt/internal/controllers/apiset"
	"github.com/defn/dev/m/tilt/internal/localexec"
	"github.com/defn/dev/m/tilt/internal/tiltfile/cisettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/hasher"
	"github.com/defn/dev/m/tilt/internal/tiltfile/links"
	"github.com/defn/dev/m/tilt/internal/tiltfile/print"
	"github.com/defn/dev/m/tilt/internal/tiltfile/probe"
	"github.com/defn/dev/m/tilt/internal/tiltfile/sys"
	"github.com/defn/dev/m/tilt/internal/tiltfile/tiltextension"

	"github.com/defn/dev/m/tilt/internal/feature"
	"github.com/defn/dev/m/tilt/internal/tiltfile/config"
	"github.com/defn/dev/m/tilt/internal/tiltfile/encoding"
	"github.com/defn/dev/m/tilt/internal/tiltfile/git"
	"github.com/defn/dev/m/tilt/internal/tiltfile/include"
	"github.com/defn/dev/m/tilt/internal/tiltfile/io"
	"github.com/defn/dev/m/tilt/internal/tiltfile/loaddynamic"
	"github.com/defn/dev/m/tilt/internal/tiltfile/os"
	"github.com/defn/dev/m/tilt/internal/tiltfile/secretsettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/shlex"
	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"
	"github.com/defn/dev/m/tilt/internal/tiltfile/starlarkstruct"
	"github.com/defn/dev/m/tilt/internal/tiltfile/updatesettings"
	tfv1alpha1 "github.com/defn/dev/m/tilt/internal/tiltfile/v1alpha1"
	"github.com/defn/dev/m/tilt/internal/tiltfile/version"
	"github.com/defn/dev/m/tilt/internal/tiltfile/watch"
	fwatch "github.com/defn/dev/m/tilt/internal/watch"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

var pkgInitTime = time.Now()

type tiltfileState struct {
	// set at creation
	ctx    context.Context
	execer localexec.Execer
	versionPlugin    version.Plugin
	configPlugin     *config.Plugin
	extensionPlugin  *tiltextension.Plugin
	ciSettingsPlugin cisettings.Plugin
	features         feature.FeatureSet

	// added to during execution
	localResources []*localResource
	localByName    map[string]*localResource

	// count how many times each builtin is called, for analytics
	builtinCallCounts map[string]int
	// how many times each arg is used on each builtin
	builtinArgCounts map[string]map[string]int

	// global trigger mode -- will be the default for all manifests (tho user can still explicitly set
	// triggerMode for a specific manifest)
	triggerMode triggerMode

	// for error reporting in case it's called twice
	triggerModeCallPosition syntax.Position

	secretSettings model.SecretSettings

	apiObjects apiset.ObjectSet

	logger logger.Logger

	// postExecReadFiles is generally a mistake -- it means that if tiltfile execution fails,
	// these will never be read. Remove these when you can!!!
	postExecReadFiles []string

	// Temporary directory for storing generated artifacts during the lifetime of the tiltfile context.
	// The directory is recursively deleted when the context is done.
	scratchDir *fwatch.TempDir
}

func newTiltfileState(
	ctx context.Context,
	execer localexec.Execer,
	versionPlugin version.Plugin,
	configPlugin *config.Plugin,
	extensionPlugin *tiltextension.Plugin,
	ciSettingsPlugin cisettings.Plugin,
	features feature.FeatureSet) *tiltfileState {
	return &tiltfileState{
		ctx:    ctx,
		execer: execer,
		versionPlugin:     versionPlugin,
		configPlugin:      configPlugin,
		extensionPlugin:   extensionPlugin,
		ciSettingsPlugin:  ciSettingsPlugin,
		localByName:       make(map[string]*localResource),
		logger:            logger.Get(ctx),
		builtinCallCounts: make(map[string]int),
		builtinArgCounts:  make(map[string]map[string]int),
		localResources:    []*localResource{},
		triggerMode:       TriggerModeAuto,
		features:          features,
		secretSettings:    model.DefaultSecretSettings(),
		apiObjects:        apiset.ObjectSet{},
	}
}

// print() for fulfilling the starlark thread callback
func (s *tiltfileState) print(_ *starlark.Thread, msg string) {
	s.logger.Infof("%s", msg)
}

// Load loads the Tiltfile in `filename`, and returns the manifests matching `matching`.
//
// This often returns a starkit.Model even on error, because the starkit.Model
// has a record of what happened during the execution (what files were read, etc).
//
// TODO(nick): Eventually this will just return a starkit.Model, which will contain
// all the mutable state collected by execution.
func (s *tiltfileState) loadManifests(tf *v1alpha1.Tiltfile) ([]model.Manifest, starkit.Model, error) {
	s.logger.Infof("Loading Tiltfile at: %s", tf.Spec.Path)

	result, err := starkit.ExecFile(tf,
		s,
		include.IncludeFn{},
		git.NewPlugin(),
		os.NewPlugin(),
		sys.NewPlugin(),
		io.NewPlugin(),
		s.versionPlugin,
		s.configPlugin,
		starlarkstruct.NewPlugin(),
		updatesettings.NewPlugin(),
		s.ciSettingsPlugin,
		secretsettings.NewPlugin(),
		encoding.NewPlugin(),
		shlex.NewPlugin(),
		watch.NewPlugin(),
		loaddynamic.NewPlugin(),
		s.extensionPlugin,
		links.NewPlugin(),
		print.NewPlugin(),
		probe.NewPlugin(),
		tfv1alpha1.NewPlugin(),
		hasher.NewPlugin(),
	)
	if err != nil {
		return nil, result, starkit.UnpackBacktrace(err)
	}

	manifests := []model.Manifest{}

	localManifests, err := s.translateLocal()
	if err != nil {
		return nil, result, err
	}
	manifests = append(manifests, localManifests...)

	err = s.sanitizeDependencies(manifests)
	if err != nil {
		return nil, starkit.Model{}, err
	}

	for i := range manifests {
		// ensure all manifests have a label indicating they're owned
		// by the Tiltfile - some reconcilers have special handling
		l := manifests[i].Labels
		if l == nil {
			l = make(map[string]string)
		}
		manifests[i] = manifests[i].WithLabels(l)

		err := manifests[i].Validate()
		if err != nil {
			// Even on manifest validation errors, we may be able
			// to use other kinds of models (e.g., watched files)
			return manifests, result, err
		}
	}

	return manifests, result, nil
}

// Builtin functions

const (
	// local resource functions
	localResourceN = "local_resource"

	// file functions
	localN = "local"

	// trigger mode
	triggerModeN       = "trigger_mode"
	triggerModeAutoN   = "TRIGGER_MODE_AUTO"
	triggerModeManualN = "TRIGGER_MODE_MANUAL"

	// feature flags
	enableFeatureN  = "enable_feature"
	disableFeatureN = "disable_feature"
)

type triggerMode int

func (m triggerMode) String() string {
	switch m {
	case TriggerModeAuto:
		return triggerModeAutoN
	case TriggerModeManual:
		return triggerModeManualN
	default:
		return fmt.Sprintf("unknown trigger mode with value %d", m)
	}
}

func (t triggerMode) Type() string {
	return "TriggerMode"
}

func (t triggerMode) Freeze() {
	// noop
}

func (t triggerMode) Truth() starlark.Bool {
	return starlark.MakeInt(int(t)).Truth()
}

func (t triggerMode) Hash() (uint32, error) {
	return starlark.MakeInt(int(t)).Hash()
}

var _ starlark.Value = triggerMode(0)

const (
	TriggerModeUnset  triggerMode = iota
	TriggerModeAuto   triggerMode = iota
	TriggerModeManual triggerMode = iota
)

func (s *tiltfileState) triggerModeForResource(resourceTriggerMode triggerMode) triggerMode {
	if resourceTriggerMode != TriggerModeUnset {
		return resourceTriggerMode
	} else {
		return s.triggerMode
	}
}

func starlarkTriggerModeToModel(triggerMode triggerMode, autoInit bool) (model.TriggerMode, error) {
	switch triggerMode {
	case TriggerModeAuto:
		if !autoInit {
			return model.TriggerModeAutoWithManualInit, nil
		}
		return model.TriggerModeAuto, nil
	case TriggerModeManual:
		if autoInit {
			return model.TriggerModeManualWithAutoInit, nil
		} else {
			return model.TriggerModeManual, nil
		}
	default:
		return 0, fmt.Errorf("unknown triggerMode %v", triggerMode)
	}
}

// count how many times each Builtin is called, for analytics
func (s *tiltfileState) OnBuiltinCall(name string, fn *starlark.Builtin) {
	s.builtinCallCounts[name]++
}

func (s *tiltfileState) OnExec(t *starlark.Thread, tiltfilePath string, contents []byte) error {
	return nil
}

func (s *tiltfileState) unpackArgs(fnname string, args starlark.Tuple, kwargs []starlark.Tuple, pairs ...interface{}) error {
	err := starlark.UnpackArgs(fnname, args, kwargs, pairs...)
	if err == nil {
		var paramNames []string
		for i, o := range pairs {
			if i%2 == 0 {
				name := strings.TrimSuffix(o.(string), "?")
				paramNames = append(paramNames, name)
			}
		}

		usedParamNames := paramNames[:args.Len()]
		for _, p := range kwargs {
			name := strings.TrimSuffix(string(p[0].(starlark.String)), "?")
			usedParamNames = append(usedParamNames, name)
		}
		_, ok := s.builtinArgCounts[fnname]
		if !ok {
			s.builtinArgCounts[fnname] = make(map[string]int)
		}
		for _, paramName := range usedParamNames {
			s.builtinArgCounts[fnname][paramName]++
		}
	}
	return err
}

// TODO(nick): Split these into separate plugins
func (s *tiltfileState) OnStart(e *starkit.Environment) error {
	e.SetArgUnpacker(s.unpackArgs)
	e.SetPrint(s.print)
	e.SetContext(s.ctx)

	for _, b := range []struct {
		name    string
		builtin starkit.Function
	}{
		{localN, s.local},
		{localResourceN, s.localResource},
		{triggerModeN, s.triggerModeFn},
		{enableFeatureN, s.enableFeature},
		{disableFeatureN, s.disableFeature},
	} {
		err := e.AddBuiltin(b.name, b.builtin)
		if err != nil {
			return err
		}
	}

	for _, v := range []struct {
		name  string
		value starlark.Value
	}{
		{triggerModeAutoN, TriggerModeAuto},
		{triggerModeManualN, TriggerModeManual},
	} {
		err := e.AddValue(v.name, v.value)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *tiltfileState) triggerModeFn(thread *starlark.Thread, fn *starlark.Builtin, args starlark.Tuple, kwargs []starlark.Tuple) (starlark.Value, error) {
	var triggerMode triggerMode
	err := s.unpackArgs(fn.Name(), args, kwargs, "trigger_mode", &triggerMode)
	if err != nil {
		return nil, err
	}

	if s.triggerModeCallPosition.IsValid() {
		return starlark.None, fmt.Errorf("%s can only be called once. It was already called at %s", fn.Name(), s.triggerModeCallPosition.String())
	}

	s.triggerMode = triggerMode
	s.triggerModeCallPosition = thread.CallFrame(1).Pos

	return starlark.None, nil
}

func (s *tiltfileState) translateLocal() ([]model.Manifest, error) {
	var result []model.Manifest

	for _, r := range s.localResources {
		mn := model.ManifestName(r.name)
		tm, err := starlarkTriggerModeToModel(s.triggerModeForResource(r.triggerMode), r.autoInit)
		if err != nil {
			return nil, fmt.Errorf("error in resource %s options: %w", mn, err)
		}

		paths := append([]string{}, r.deps...)
		paths = append(paths, r.threadDir)

		ignores := repoIgnoresForPaths(paths)
		if len(r.ignores) != 0 {
			ignores = append(ignores, v1alpha1.IgnoreDef{
				BasePath: r.threadDir,
				Patterns: r.ignores,
			})
		}

		lt := model.NewLocalTarget(model.TargetName(r.name), r.updateCmd, r.serveCmd, r.deps).
			WithAllowParallel(r.allowParallel || r.updateCmd.Empty()).
			WithLinks(r.links).
			WithReadinessProbe(r.readinessProbe)
		lt.FileWatchIgnores = ignores

		var mds []model.ManifestName
		for _, md := range r.resourceDeps {
			mds = append(mds, model.ManifestName(md))
		}
		m := model.Manifest{
			Name:        mn,
			TriggerMode: tm,
		}.WithLocalTarget(lt)

		m = m.WithLabels(r.labels)

		result = append(result, m)
	}

	return result, nil
}

func (s *tiltfileState) tempDir() (*fwatch.TempDir, error) {
	if s.scratchDir == nil {
		dir, err := fwatch.NewDir("tiltfile")
		if err != nil {
			return dir, err
		}
		s.scratchDir = dir
		go func() {
			<-s.ctx.Done()
			_ = s.scratchDir.TearDown()
		}()
	}
	return s.scratchDir, nil
}

func (s *tiltfileState) sanitizeDependencies(ms []model.Manifest) error {
	// warn + delete resource deps that don't exist
	// error if resource deps are not a DAG

	knownResources := make(map[model.ManifestName]bool)
	for _, m := range ms {
		knownResources[m.Name] = true
	}

	// construct the graph and make sure all edges are valid
	edges := make(map[interface{}][]interface{})
	for i, m := range ms {
		var sanitizedDeps []model.ManifestName
		for _, b := range m.ResourceDependencies {
			if m.Name == b {
				return fmt.Errorf("resource %s specified a dependency on itself", m.Name)
			}
			if _, ok := knownResources[b]; !ok {
				logger.Get(s.ctx).Warnf("resource %s specified a dependency on unknown resource %s - dependency ignored", m.Name, b)
				continue
			}
			edges[m.Name] = append(edges[m.Name], b)
			sanitizedDeps = append(sanitizedDeps, b)
		}

		m.ResourceDependencies = sanitizedDeps
		ms[i] = m
	}

	// check for cycles
	connections := tarjan.Connections(edges)
	for _, g := range connections {
		if len(g) > 1 {
			var nodes []string
			for i := range g {
				nodes = append(nodes, string(g[len(g)-i-1].(model.ManifestName)))
			}
			nodes = append(nodes, string(g[len(g)-1].(model.ManifestName)))
			return fmt.Errorf("cycle detected in resource dependency graph: %s", strings.Join(nodes, " -> "))
		}
	}

	return nil
}

var _ starkit.Plugin = &tiltfileState{}
var _ starkit.OnExecPlugin = &tiltfileState{}
var _ starkit.OnBuiltinCallPlugin = &tiltfileState{}
