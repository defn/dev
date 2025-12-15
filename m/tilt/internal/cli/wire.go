//go:build wireinject
// +build wireinject

// The build tag makes sure the stub is not built in the final build.

package cli

import (
	"context"
	"time"

	cliclient "github.com/defn/dev/m/tilt/internal/cli/client"
	"github.com/defn/dev/m/tilt/internal/controllers/core/filewatch/fsevent"
	"github.com/tilt-dev/clusterid"

	"github.com/google/wire"
	"github.com/jonboulle/clockwork"

	"github.com/tilt-dev/wmclient/pkg/dirs"

	"github.com/defn/dev/m/tilt/internal/controllers"
	"github.com/defn/dev/m/tilt/internal/engine"
	"github.com/defn/dev/m/tilt/internal/engine/configs"
	"github.com/defn/dev/m/tilt/internal/engine/local"
	"github.com/defn/dev/m/tilt/internal/engine/session"
	"github.com/defn/dev/m/tilt/internal/engine/uiresource"
	"github.com/defn/dev/m/tilt/internal/engine/uisession"
	"github.com/defn/dev/m/tilt/internal/feature"
	"github.com/defn/dev/m/tilt/internal/git"
	"github.com/defn/dev/m/tilt/internal/hud"
	"github.com/defn/dev/m/tilt/internal/hud/prompt"
	"github.com/defn/dev/m/tilt/internal/localexec"
	"github.com/defn/dev/m/tilt/internal/openurl"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/tiltfile"
	"github.com/defn/dev/m/tilt/internal/token"
	"github.com/defn/dev/m/tilt/internal/xdg"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

var BaseWireSet = wire.NewSet(
	tiltfile.WireSet,
	git.ProvideGitRemote,

	localexec.DefaultEnv,
	localexec.NewProcessExecer,
	wire.Bind(new(localexec.Execer), new(*localexec.ProcessExecer)),

	clockwork.NewRealClock,
	local.NewServerController,
	uisession.NewSubscriber,
	uiresource.NewSubscriber,
	configs.NewConfigsController,
	configs.NewTriggerQueueSubscriber,
	session.NewController,

	provideClock,
	provideLogSource,
	provideLogResources,
	provideLogLevel,
	hud.WireSet,
	prompt.WireSet,
	wire.Value(openurl.OpenURL(openurl.BrowserOpen)),

	provideLogActions,
	store.NewStore,
	wire.Bind(new(store.RStore), new(*store.Store)),
	wire.Bind(new(store.Dispatcher), new(*store.Store)),

	provideTiltInfo,
	engine.NewUpper,
	fsevent.ProvideWatcherMaker,
	fsevent.ProvideTimerMaker,

	controllers.WireSet,

	provideCITimeoutFlag,

	dirs.UseTiltDevDir,
	xdg.NewTiltDevBase,
	token.GetOrCreateToken,

	wire.Value(feature.MainDefaults),

	// Provide a default env for non-K8s mode
	wire.Value(clusterid.Product("")),
)

var CLIClientWireSet = wire.NewSet(
	BaseWireSet,
	cliclient.WireSet,
)

var UpWireSet = wire.NewSet(
	BaseWireSet,
	engine.ProvideSubscribers,
)

func wireTiltfileResult(ctx context.Context, subcommand model.TiltSubcommand) (cmdTiltfileResultDeps, error) {
	wire.Build(UpWireSet, newTiltfileResultDeps)
	return cmdTiltfileResultDeps{}, nil
}

func wireCmdUp(ctx context.Context, subcommand model.TiltSubcommand) (CmdUpDeps, error) {
	wire.Build(UpWireSet,
		wire.Value(store.EngineModeUp),
		wire.Struct(new(CmdUpDeps), "*"))
	return CmdUpDeps{}, nil
}

type CmdUpDeps struct {
	Upper     engine.Upper
	TiltBuild model.TiltBuild
	Token     token.Token
	Prompt    *prompt.TerminalPrompt
}

func wireCmdCI(ctx context.Context, subcommand model.TiltSubcommand) (CmdCIDeps, error) {
	wire.Build(UpWireSet,
		wire.Value(store.EngineModeCI),
		wire.Struct(new(CmdCIDeps), "*"),
	)
	return CmdCIDeps{}, nil
}

type CmdCIDeps struct {
	Upper     engine.Upper
	TiltBuild model.TiltBuild
	Token     token.Token
}

func wireLogsDeps(ctx context.Context, subcommand model.TiltSubcommand) (LogsDeps, error) {
	wire.Build(UpWireSet,
		wire.Struct(new(LogsDeps), "*"))
	return LogsDeps{}, nil
}

type LogsDeps struct {
	printer *hud.IncrementalPrinter
	filter  hud.LogFilter
}

func provideClock() func() time.Time {
	return time.Now
}

func wireClientGetter(ctx context.Context) (*cliclient.Getter, error) {
	wire.Build(CLIClientWireSet)
	return nil, nil
}

func wireLsp(ctx context.Context, l logger.Logger, subcommand model.TiltSubcommand) (cmdLspDeps, error) {
	wire.Build(UpWireSet, newLspDeps)
	return cmdLspDeps{}, nil
}

func provideCITimeoutFlag() model.CITimeoutFlag {
	return model.CITimeoutFlag(ciTimeout)
}

func provideLogSource() hud.FilterSource {
	return hud.FilterSource(logSourceFlag)
}

func provideLogResources() hud.FilterResources {
	result := []model.ManifestName{}
	for _, r := range logResourcesFlag {
		result = append(result, model.ManifestName(r))
	}
	return hud.FilterResources(result)
}

func provideLogLevel() hud.FilterLevel {
	switch logLevelFlag {
	case "warn", "WARN", "warning", "WARNING":
		return hud.FilterLevel(logger.WarnLvl)
	case "error", "ERROR":
		return hud.FilterLevel(logger.ErrorLvl)
	default:
		return hud.FilterLevel(logger.NoneLvl)
	}
}
