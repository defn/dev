package tiltfile

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"go.starlark.net/starlark"

	"github.com/defn/dev/m/tilt/internal/controllers/apiset"
	"github.com/defn/dev/m/tilt/internal/feature"
	"github.com/defn/dev/m/tilt/internal/localexec"
	"github.com/defn/dev/m/tilt/internal/ospath"
	"github.com/defn/dev/m/tilt/internal/sliceutils"
	"github.com/defn/dev/m/tilt/internal/tiltfile/cisettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/config"
	"github.com/defn/dev/m/tilt/internal/tiltfile/hasher"
	"github.com/defn/dev/m/tilt/internal/tiltfile/io"
	"github.com/defn/dev/m/tilt/internal/tiltfile/secretsettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/starkit"
	"github.com/defn/dev/m/tilt/internal/tiltfile/tiltextension"
	"github.com/defn/dev/m/tilt/internal/tiltfile/updatesettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/v1alpha1"
	"github.com/defn/dev/m/tilt/internal/tiltfile/value"
	"github.com/defn/dev/m/tilt/internal/tiltfile/version"
	"github.com/defn/dev/m/tilt/internal/tiltfile/watch"
	corev1alpha1 "github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/tilt-dev/clusterid"
)

const FileName = "Tiltfile"

type TiltfileLoadResult struct {
	Manifests        []model.Manifest
	EnabledManifests []model.ManifestName
	Tiltignore       model.Dockerignore
	ConfigFiles      []string
	FeatureFlags     map[string]bool
	Secrets          model.SecretSet
	Error            error
	VersionSettings  model.VersionSettings
	UpdateSettings   model.UpdateSettings
	WatchSettings    model.WatchSettings
	ObjectSet        apiset.ObjectSet
	Hashes           hasher.Hashes
	CISettings       *corev1alpha1.SessionCISpec

	// For diagnostic purposes only
	BuiltinCalls []starkit.BuiltinCall `json:"-"`
}

func (r TiltfileLoadResult) WithAllManifestsEnabled() TiltfileLoadResult {
	r.EnabledManifests = nil
	for _, m := range r.Manifests {
		r.EnabledManifests = append(r.EnabledManifests, m.Name)
	}
	return r
}

type TiltfileLoader interface {
	// Load the Tiltfile.
	//
	// By design, Load() always returns a result.
	// We want to be very careful not to treat non-zero exit codes like an error.
	// Because even if the Tiltfile has errors, we might need to watch files
	// or return partial results (like enabled features).
	Load(ctx context.Context, tf *corev1alpha1.Tiltfile, prevResult *TiltfileLoadResult) TiltfileLoadResult
}

func ProvideTiltfileLoader(
	versionPlugin version.Plugin,
	configPlugin *config.Plugin,
	extensionPlugin *tiltextension.Plugin,
	ciSettingsPlugin cisettings.Plugin,
	webHost model.WebHost,
	execer localexec.Execer,
	fDefaults feature.Defaults,
	env clusterid.Product) TiltfileLoader {
	return tiltfileLoader{
		versionPlugin:    versionPlugin,
		configPlugin:     configPlugin,
		extensionPlugin:  extensionPlugin,
		ciSettingsPlugin: ciSettingsPlugin,
		webHost:          webHost,
		execer:           execer,
		fDefaults:        fDefaults,
		env:              env,
	}
}

type tiltfileLoader struct {
	webHost model.WebHost
	execer  localexec.Execer

	versionPlugin    version.Plugin
	configPlugin     *config.Plugin
	extensionPlugin  *tiltextension.Plugin
	ciSettingsPlugin cisettings.Plugin
	fDefaults        feature.Defaults
	env              clusterid.Product
}

var _ TiltfileLoader = &tiltfileLoader{}

// Load loads the Tiltfile in `filename`
func (tfl tiltfileLoader) Load(ctx context.Context, tf *corev1alpha1.Tiltfile, prevResult *TiltfileLoadResult) TiltfileLoadResult {
	start := time.Now()
	filename := tf.Spec.Path
	absFilename, err := ospath.RealAbs(tf.Spec.Path)
	if err != nil {
		if os.IsNotExist(err) {
			return TiltfileLoadResult{
				ConfigFiles: []string{filename},
				Error:       fmt.Errorf("No Tiltfile found at paths '%s'. Check out https://docs.tilt.dev/tutorial.html", filename),
			}
		}
		absFilename, _ = filepath.Abs(filename)
		return TiltfileLoadResult{
			ConfigFiles: []string{absFilename},
			Error:       err,
		}
	}

	tiltignorePath := watch.TiltignorePath(absFilename)
	tlr := TiltfileLoadResult{
		ConfigFiles: []string{absFilename, tiltignorePath},
	}

	tiltignore, err := watch.ReadTiltignore(tiltignorePath)

	// missing tiltignore is fine, but a filesystem error is not
	if err != nil {
		tlr.Error = err
		return tlr
	}

	tlr.Tiltignore = tiltignore

	s := newTiltfileState(ctx, tfl.webHost, tfl.execer, tfl.versionPlugin,
		tfl.configPlugin, tfl.extensionPlugin, tfl.ciSettingsPlugin, feature.FromDefaults(tfl.fDefaults))

	manifests, result, err := s.loadManifests(tf)

	tlr.BuiltinCalls = result.BuiltinCalls

	// All data models are loaded with GetState. We ignore the error if the state
	// isn't properly loaded. This is necessary for handling partial Tiltfile
	// execution correctly, where some state is correctly assembled but other
	// state is not (and should be assumed empty).
	ws, _ := watch.GetState(result)
	tlr.WatchSettings = ws

	// NOTE(maia): if/when add secret settings that affect the engine, add them to tlr here
	ss, _ := secretsettings.GetState(result)
	s.secretSettings = ss

	ioState, _ := io.GetState(result)

	tlr.ConfigFiles = append(tlr.ConfigFiles, ioState.Paths...)
	tlr.ConfigFiles = append(tlr.ConfigFiles, s.postExecReadFiles...)
	tlr.ConfigFiles = sliceutils.DedupedAndSorted(tlr.ConfigFiles)

	tlr.Secrets = s.extractSecrets()
	tlr.FeatureFlags = s.features.ToEnabled()
	tlr.Error = err
	tlr.Manifests = manifests

	objectSet, _ := v1alpha1.GetState(result)
	tlr.ObjectSet = objectSet

	vs, _ := version.GetState(result)
	tlr.VersionSettings = vs

	us, _ := updatesettings.GetState(result)
	tlr.UpdateSettings = us

	ci, _ := cisettings.GetState(result)
	tlr.CISettings = ci

	configSettings, _ := config.GetState(result)
	if tlr.Error == nil {
		tlr.EnabledManifests, tlr.Error = configSettings.EnabledResources(tf, manifests)
	}

	duration := time.Since(start)
	if tlr.Error == nil {
		s.logger.Infof("Successfully loaded Tiltfile (%s)", duration)
	}
	hashState, _ := hasher.GetState(result)
	tlr.Hashes = hashState.GetHashes()

	return tlr
}

func starlarkValueOrSequenceToSlice(v starlark.Value) []starlark.Value {
	return value.ValueOrSequenceToSlice(v)
}
