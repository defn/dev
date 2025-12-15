package cli

import (
	"context"
	_ "embed"
	"errors"
	"log"
	"os"

	"github.com/mattn/go-isatty"
	"github.com/spf13/cobra"

	"github.com/defn/dev/m/tilt/internal/controllers"
	"github.com/defn/dev/m/tilt/internal/hud/prompt"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

var (
	logActionsFlag   bool     = false
	logSourceFlag    string   = ""
	logResourcesFlag []string = nil
	logLevelFlag     string   = ""
)

var userExitError = errors.New("user requested Tilt exit")

//go:embed Tiltfile.starter
var starterTiltfile []byte

type upCmd struct {
	fileName string

	legacy bool
	stream bool
}

func (c *upCmd) name() model.TiltSubcommand { return "up" }

func (c *upCmd) register() *cobra.Command {
	cmd := &cobra.Command{
		Use:                   "up [<tilt flags>] [-- <Tiltfile args>]",
		DisableFlagsInUseLine: true,
		Short:                 "Start Tilt with the given Tiltfile args",
		Long: `
Starts Tilt and runs services defined in the Tiltfile.

There are two types of args:
1) Tilt flags, listed below, which are handled entirely by Tilt.
2) Tiltfile args, which can be anything, and are potentially accessed by config.parse in your Tiltfile.

By default:
1) Tiltfile args are interpreted as the list of services to start, e.g. tilt up frontend backend.
2) Running with no Tiltfile args starts all services defined in the Tiltfile

This default behavior does not apply if the Tiltfile uses config.parse or config.set_enabled_resources.
In that case, see https://docs.tilt.dev/tiltfile_config.html and/or comments in your Tiltfile

When you exit Tilt (using Ctrl+C), any long-running local resources--i.e. those using serve_cmd--are terminated.
`,
	}

	cmd.Flags().BoolVar(&c.legacy, "legacy", false, "If true, tilt will open in legacy terminal mode.")
	cmd.Flags().BoolVar(&c.stream, "stream", false, "If true, tilt will stream logs in the terminal.")
	cmd.Flags().BoolVar(&logActionsFlag, "logactions", false, "log all actions and state changes")
	addTiltfileFlag(cmd, &c.fileName)
	addLogFilterFlags(cmd, "log-")
	addLogFilterResourcesFlag(cmd)
	cmd.Flags().Lookup("logactions").Hidden = true

	return cmd
}

func (c *upCmd) initialTermMode(isTerminal bool) store.TerminalMode {
	if !isTerminal {
		return store.TerminalModeStream
	}

	if c.legacy {
		return store.TerminalModeHUD
	}

	if c.stream {
		return store.TerminalModeStream
	}

	return store.TerminalModePrompt
}

func (c *upCmd) run(ctx context.Context, args []string) error {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	log.SetFlags(log.Flags() &^ (log.Ldate | log.Ltime))
	isTTY := isatty.IsTerminal(os.Stdout.Fd())
	termMode := c.initialTermMode(isTTY)

	generateTiltfileResult, err := maybeGenerateTiltfile(c.fileName)
	if err == userExitError {
		return nil
	} else if err != nil {
		return err
	}
	_ = generateTiltfileResult // unused now that analytics is removed

	deferred := logger.NewDeferredLogger(ctx)
	ctx = redirectLogs(ctx, deferred)

	startLine := prompt.StartStatusLine(model.WebURL{}, "")
	log.Print(startLine)
	log.Print(buildStamp())

	cmdUpDeps, err := wireCmdUp(ctx, "up")
	if err != nil {
		deferred.SetOutput(deferred.Original())
		return err
	}

	upper := cmdUpDeps.Upper
	if termMode == store.TerminalModePrompt {
		// Any logs that showed up during initialization, make sure they're
		// in the prompt.
		cmdUpDeps.Prompt.SetInitOutput(deferred.CopyBuffered(logger.InfoLvl))
	}

	l := store.NewLogActionLogger(ctx, upper.Dispatch)
	deferred.SetOutput(l)
	ctx = redirectLogs(ctx, l)

	err = upper.Start(ctx, args, cmdUpDeps.TiltBuild,
		c.fileName, termMode, cmdUpDeps.Token, "")
	if err != context.Canceled {
		return err
	} else {
		return nil
	}
}

func redirectLogs(ctx context.Context, l logger.Logger) context.Context {
	ctx = logger.WithLogger(ctx, l)
	log.SetOutput(l.Writer(logger.InfoLvl))
	controllers.MaybeSetKlogOutput(l.Writer(logger.InfoLvl))
	return ctx
}

func provideLogActions() store.LogActionsFlag {
	return store.LogActionsFlag(logActionsFlag)
}
