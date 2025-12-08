package cli

import (
	"os"
	"strings"
	"time"

	"github.com/spf13/cobra"

	tiltanalytics "github.com/defn/dev/m/tilt/internal/analytics"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extension"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extensionrepo"
	"github.com/defn/dev/m/tilt/internal/engine/analytics"
	"github.com/defn/dev/m/tilt/internal/lsp"
	"github.com/defn/dev/m/tilt/internal/tiltfile"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/tilt-dev/starlark-lsp/pkg/cli"
)

func reportLspInvocation(a *tiltanalytics.TiltAnalytics, cmdParts []string) {
	a.Incr("cmd."+strings.Join(cmdParts, "."), make(analytics.CmdTags))
	a.Flush(time.Second)
}

type cmdLspDeps struct {
	repo      *extensionrepo.Reconciler
	ext       *extension.Reconciler
	analytics *tiltanalytics.TiltAnalytics
}

func newLspDeps(
	repo *extensionrepo.Reconciler,
	ext *extension.Reconciler,
	analytics *tiltanalytics.TiltAnalytics,
) cmdLspDeps {
	return cmdLspDeps{
		repo:      repo,
		ext:       ext,
		analytics: analytics,
	}
}

func newLspCmd() *cobra.Command {
	extFinder := lsp.NewExtensionFinder()
	rootCmd := cli.NewRootCmd("tilt lsp", tiltfile.ApiStubs, extFinder.ManagerOptions()...)
	rootCmd.Use = "lsp"
	origPersistentPreRunE := rootCmd.PersistentPreRunE
	rootCmd.PersistentPreRunE = func(cmd *cobra.Command, args []string) error {
		if origPersistentPreRunE != nil {
			err := origPersistentPreRunE(cmd, args)
			if err != nil {
				return err
			}
		} else if rootCmd.PersistentPreRun != nil {
			// cobra will only execute PersistentPreRun if there's no PersistentPreRunE - if the underlying command
			// defined a PersistentPreRun, we've preempted it by defining a PersistentPreRunE, even though we haven't
			// replaced it. So, we need to execute it ourselves.
			rootCmd.PersistentPreRun(cmd, args)
		}

		l := logger.NewLogger(logLevel(verbose, debug), os.Stdout)
		ctx := logger.WithLogger(cmd.Context(), l)
		cmdParts := []string{"lsp"}
		if cmd.Name() != "lsp" {
			cmdParts = append(cmdParts, cmd.Name())
		}
		deps, err := wireLsp(ctx, l, model.TiltSubcommand(strings.Join(cmdParts, " ")))
		if err != nil {
			return err
		}

		extFinder.Initialize(ctx, deps.repo, deps.ext)
		reportLspInvocation(deps.analytics, cmdParts)
		return nil
	}
	return rootCmd.Command
}
