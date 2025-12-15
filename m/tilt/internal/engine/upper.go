package engine

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/davecgh/go-spew/spew"

	"github.com/defn/dev/m/tilt/internal/controllers/core/filewatch"
	ctrltiltfile "github.com/defn/dev/m/tilt/internal/controllers/core/tiltfile"
	"github.com/defn/dev/m/tilt/internal/engine/local"
	"github.com/defn/dev/m/tilt/internal/hud"
	"github.com/defn/dev/m/tilt/internal/hud/prompt"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/store/configmaps"
	"github.com/defn/dev/m/tilt/internal/store/filewatches"
	"github.com/defn/dev/m/tilt/internal/store/sessions"
	"github.com/defn/dev/m/tilt/internal/store/tiltfiles"
	"github.com/defn/dev/m/tilt/internal/store/uibuttons"
	"github.com/defn/dev/m/tilt/internal/store/uiresources"
	"github.com/defn/dev/m/tilt/internal/token"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// TODO(nick): maybe this should be called 'BuildEngine' or something?
// Upper seems like a poor and undescriptive name.
type Upper struct {
	store *store.Store
}

type ServiceWatcherMaker func(context.Context, *store.Store) error
type PodWatcherMaker func(context.Context, *store.Store) error

func NewUpper(ctx context.Context, st *store.Store, subs []store.Subscriber) (Upper, error) {
	// There's not really a good reason to add all the subscribers
	// in NewUpper(), but it's as good a place as any.
	for _, sub := range subs {
		err := st.AddSubscriber(ctx, sub)
		if err != nil {
			return Upper{}, err
		}
	}

	return Upper{
		store: st,
	}, nil
}

func (u Upper) Dispatch(action store.Action) {
	u.store.Dispatch(action)
}

func (u Upper) Start(
	ctx context.Context,
	args []string,
	b model.TiltBuild,
	fileName string,
	initTerminalMode store.TerminalMode,
	token token.Token,
	cloudAddress string,
) error {

	startTime := time.Now()

	absTfPath, err := filepath.Abs(fileName)
	if err != nil {
		return err
	}
	return u.Init(ctx, InitAction{
		TiltfilePath: absTfPath,
		UserArgs:     args,
		TiltBuild:    b,
		StartTime:    startTime,
		Token:        token,
		CloudAddress: cloudAddress,
		TerminalMode: initTerminalMode,
	})
}

func (u Upper) Init(ctx context.Context, action InitAction) error {
	u.store.Dispatch(action)
	return u.store.Loop(ctx)
}

func upperReducerFn(ctx context.Context, state *store.EngineState, action store.Action) {
	// Allow exitAction and dumpEngineStateAction even if there's a fatal error
	if exitAction, isExitAction := action.(hud.ExitAction); isExitAction {
		handleHudExitAction(state, exitAction)
		return
	}
	if _, isDumpEngineStateAction := action.(hud.DumpEngineStateAction); isDumpEngineStateAction {
		handleDumpEngineStateAction(ctx, state)
		return
	}

	if state.FatalError != nil {
		return
	}

	switch action := action.(type) {
	case InitAction:
		handleInitAction(ctx, state, action)
	case store.ErrorAction:
		state.FatalError = action.Error
	case hud.ExitAction:
		handleHudExitAction(state, action)

	// TODO(nick): Delete these handlers in favor of the bog-standard ones that copy
	// the api models directly.
	case filewatch.FileWatchUpdateStatusAction:
		filewatch.HandleFileWatchUpdateStatusEvent(ctx, state, action)

	case ctrltiltfile.ConfigsReloadStartedAction:
		ctrltiltfile.HandleConfigsReloadStarted(ctx, state, action)
	case ctrltiltfile.ConfigsReloadedAction:
		ctrltiltfile.HandleConfigsReloaded(ctx, state, action)
	case hud.DumpEngineStateAction:
		handleDumpEngineStateAction(ctx, state)
	case store.TiltCloudStatusReceivedAction:
		handleTiltCloudStatusReceivedAction(state, action)
	case store.PanicAction:
		handlePanicAction(state, action)
	case store.LogAction:
		handleLogAction(state, action)
	case store.AppendToTriggerQueueAction:
		state.AppendToTriggerQueue(action.Name, action.Reason)
	case sessions.SessionStatusUpdateAction:
		sessions.HandleSessionStatusUpdateAction(state, action)
	case prompt.SwitchTerminalModeAction:
		handleSwitchTerminalModeAction(state, action)
	case local.CmdCreateAction:
		local.HandleCmdCreateAction(state, action)
	case local.CmdUpdateStatusAction:
		local.HandleCmdUpdateStatusAction(state, action)
	case local.CmdDeleteAction:
		local.HandleCmdDeleteAction(state, action)
	case tiltfiles.TiltfileUpsertAction:
		tiltfiles.HandleTiltfileUpsertAction(state, action)
	case tiltfiles.TiltfileDeleteAction:
		tiltfiles.HandleTiltfileDeleteAction(state, action)
	case filewatches.FileWatchUpsertAction:
		filewatches.HandleFileWatchUpsertAction(state, action)
	case filewatches.FileWatchDeleteAction:
		filewatches.HandleFileWatchDeleteAction(state, action)
	case uiresources.UIResourceUpsertAction:
		uiresources.HandleUIResourceUpsertAction(state, action)
	case uiresources.UIResourceDeleteAction:
		uiresources.HandleUIResourceDeleteAction(state, action)
	case configmaps.ConfigMapUpsertAction:
		configmaps.HandleConfigMapUpsertAction(state, action)
	case configmaps.ConfigMapDeleteAction:
		configmaps.HandleConfigMapDeleteAction(state, action)
	case uibuttons.UIButtonUpsertAction:
		uibuttons.HandleUIButtonUpsertAction(state, action)
	case uibuttons.UIButtonDeleteAction:
		uibuttons.HandleUIButtonDeleteAction(state, action)
	default:
		state.FatalError = fmt.Errorf("unrecognized action: %T", action)
	}
}

var UpperReducer = store.Reducer(upperReducerFn)

func handleLogAction(state *store.EngineState, action store.LogAction) {
	state.LogStore.Append(action, state.Secrets)
}

func handleSwitchTerminalModeAction(state *store.EngineState, action prompt.SwitchTerminalModeAction) {
	state.TerminalMode = action.Mode
}

func handleDumpEngineStateAction(ctx context.Context, engineState *store.EngineState) {
	f, err := os.CreateTemp("", "tilt-engine-state-*.txt")
	if err != nil {
		logger.Get(ctx).Infof("error creating temp file to write engine state: %v", err)
		return
	}

	logger.Get(ctx).Infof("dumped tilt engine state to %q", f.Name())
	spew.Fdump(f, engineState)

	err = f.Close()
	if err != nil {
		logger.Get(ctx).Infof("error closing engine state temp file: %v", err)
		return
	}
}

func handleInitAction(ctx context.Context, engineState *store.EngineState, action InitAction) {
	engineState.TiltBuildInfo = action.TiltBuild
	engineState.TiltStartTime = action.StartTime
	engineState.DesiredTiltfilePath = action.TiltfilePath
	engineState.UserConfigState = model.NewUserConfigState(action.UserArgs)
	engineState.CloudAddress = action.CloudAddress
	engineState.Token = action.Token
	engineState.TerminalMode = action.TerminalMode
}

func handleHudExitAction(state *store.EngineState, action hud.ExitAction) {
	if action.Err != nil {
		state.FatalError = action.Err
	} else {
		state.UserExited = true
	}
}

func handlePanicAction(state *store.EngineState, action store.PanicAction) {
	state.PanicExited = action.Err
}

func handleTiltCloudStatusReceivedAction(state *store.EngineState, action store.TiltCloudStatusReceivedAction) {
	state.SuggestedTiltVersion = action.SuggestedTiltVersion
}
