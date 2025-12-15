package cli

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/fatih/color"
	"github.com/mattn/go-colorable"
	"github.com/spf13/cobra"

	"github.com/defn/dev/m/tilt/internal/hud/prompt"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

type ciCmd struct {
	fileName string
}

func (c *ciCmd) name() model.TiltSubcommand { return "ci" }

func (c *ciCmd) register() *cobra.Command {
	cmd := &cobra.Command{
		Use:                   "ci [<tilt flags>] [-- <Tiltfile args>]",
		DisableFlagsInUseLine: true,
		Short:                 "Start Tilt in CI/batch mode with the given Tiltfile args",
		Long: `
Starts Tilt and runs resources defined in the Tiltfile.

Exits with failure if any build fails or any server crashes.

Exits with success if all tasks have completed successfully
and all servers are healthy.

See blog post for additional information: https://blog.tilt.dev/2020/04/16/how-to-not-break-server-startup.html
`,
	}

	addTiltfileFlag(cmd, &c.fileName)
	addKubeContextFlag(cmd)
	addNamespaceFlag(cmd)
	addLogFilterFlags(cmd, "log-")
	addLogFilterResourcesFlag(cmd)

	cmd.Flags().BoolVar(&logActionsFlag, "logactions", false, "log all actions and state changes")
	cmd.Flags().Lookup("logactions").Hidden = true
	cmd.Flags().DurationVar(&ciTimeout, "timeout", model.CITimeoutDefault,
		"Timeout to wait for CI to pass. Set to 0 for no timeout.")

	return cmd
}

func (c *ciCmd) run(ctx context.Context, args []string) error {
	deferred := logger.NewDeferredLogger(ctx)
	ctx = redirectLogs(ctx, deferred)

	log.SetFlags(log.Flags() &^ (log.Ldate | log.Ltime))

	startLine := prompt.StartStatusLine()
	log.Print(startLine)
	log.Print(buildStamp())

	cmdCIDeps, err := wireCmdCI(ctx, "ci")
	if err != nil {
		deferred.SetOutput(deferred.Original())
		return err
	}

	upper := cmdCIDeps.Upper

	l := store.NewLogActionLogger(ctx, upper.Dispatch)
	deferred.SetOutput(l)
	ctx = redirectLogs(ctx, l)

	err = upper.Start(ctx, args, cmdCIDeps.TiltBuild,
		c.fileName, store.TerminalModeStream)
	if err == nil {
		_, _ = fmt.Fprintln(colorable.NewColorableStdout(),
			color.GreenString("SUCCESS. All workloads are healthy."))
	}
	return err
}

var ciTimeout time.Duration
