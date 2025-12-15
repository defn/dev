package cli

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/go-logr/logr"
	"github.com/spf13/cobra"
	"go.lsp.dev/protocol"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	ctrllog "sigs.k8s.io/controller-runtime/pkg/log"

	"github.com/defn/dev/m/tilt/internal/controllers"
	"github.com/defn/dev/m/tilt/internal/output"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/tilt-dev/starlark-lsp/pkg/cli"
)

var debug bool
var verbose bool

func logLevel(verbose, debug bool) logger.Level {
	if debug {
		return logger.DebugLvl
	} else if verbose {
		return logger.VerboseLvl
	} else {
		return logger.InfoLvl
	}
}

func Execute() {
	err := readEnvDefaults()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	rootCmd := &cobra.Command{
		Use:   "tilt",
		Short: "Local development with file watching",
		Long: `
Tilt helps you develop locally with file watching and automatic command execution.
Run 'tilt up' to start working on your services.

Tilt watches your files for edits and automatically runs your commands
to bring your environment up-to-date in real-time.
`,
	}
	streams := genericclioptions.IOStreams{Out: os.Stdout, ErrOut: os.Stderr, In: os.Stdin}

	addCommand(rootCmd, &ciCmd{})
	addCommand(rootCmd, &upCmd{})
	addCommand(rootCmd, &versionCmd{})
	addCommand(rootCmd, newArgsCmd(streams))

	rootCmd.AddCommand(newAlphaCmd(streams))
	rootCmd.AddCommand(newLspCmd())

	globalFlags := rootCmd.PersistentFlags()
	globalFlags.BoolVarP(&debug, "debug", "d", false, "Enable debug logging")
	globalFlags.BoolVarP(&verbose, "verbose", "v", false, "Enable verbose logging")
	controllers.AddKlogFlags(globalFlags)

	ctx, cleanup := createContext()
	defer cleanup()
	if err := rootCmd.ExecuteContext(ctx); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

type tiltCmd interface {
	name() model.TiltSubcommand
	register() *cobra.Command
	run(ctx context.Context, args []string) error
}

func createContext() (ctx context.Context, cleanup func()) {
	l, cleanup := cli.NewLogger()
	return protocol.WithLogger(context.Background(), l), cleanup
}

func preCommand(ctx context.Context, cmdName model.TiltSubcommand) context.Context {
	_ = cmdName // unused now that analytics is removed

	l := logger.NewLogger(logLevel(verbose, debug), os.Stdout)
	ctx = logger.WithLogger(ctx, l)

	// Users don't care about controller-runtime logs.
	ctrllog.SetLogger(logr.New(ctrllog.NullLogSink{}))

	controllers.InitKlog(l.Writer(logger.InfoLvl))

	// SIGNAL TRAPPING
	ctx, cancel := context.WithCancel(ctx)
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP)
	go func() {
		<-sigs

		cancel()

		// If we get another signal, OR it takes too long for tilt to
		// exit after canceling context, just exit
		select {
		case <-sigs:
			l.Debugf("force quitting...")
			os.Exit(1)
		case <-time.After(2 * time.Second):
			l.Debugf("Context canceled but app still running; forcibly exiting.")
			os.Exit(1)
		}
	}()

	return ctx
}

func addCommand(parent *cobra.Command, child tiltCmd) {
	cobraChild := child.register()
	cobraChild.Run = func(cmd *cobra.Command, args []string) {
		ctx := preCommand(cmd.Context(), child.name())

		err := child.run(ctx, args)
		if err != nil {
			// TODO(maia): this shouldn't print if we've already pretty-printed it
			_, printErr := fmt.Fprintf(output.OriginalStderr, "Error: %v\n", err)
			if printErr != nil {
				panic(printErr)
			}
			os.Exit(1)
		}
	}

	parent.AddCommand(cobraChild)
}
