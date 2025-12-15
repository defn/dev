package agent

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"

	"github.com/defn/dev/m/flyctl/agent"
	"github.com/defn/dev/m/flyctl/iostreams"

	"github.com/defn/dev/m/flyctl/internal/command"
	"github.com/defn/dev/m/flyctl/internal/config"
	"github.com/defn/dev/m/flyctl/internal/flag"
	"github.com/defn/dev/m/flyctl/internal/render"
)

func newResolve() (cmd *cobra.Command) {
	const (
		short = "Resolve the IP of a host[:port]"
		long  = short + "\n"
		usage = "resolve <slug> <host[:port]>"
	)

	cmd = command.New(usage, short, long, runResolve,
		command.RequireSession,
	)

	cmd.Args = cobra.ExactArgs(2)

	flag.Add(cmd, flag.JSONOutput())
	return
}

func runResolve(ctx context.Context) (err error) {
	var client *agent.Client
	if client, err = establish(ctx); err != nil {
		return
	}

	var (
		args     = flag.Args(ctx)
		slug     = args[0]
		hostport = args[1]
	)

	addr, err := client.Resolve(ctx, slug, hostport, "")
	if err != nil {
		return
	}

	if out := iostreams.FromContext(ctx).Out; config.FromContext(ctx).JSONOutput {
		err = render.JSON(out, struct {
			Addr string `json:"addr"`
		}{
			Addr: addr,
		})
	} else {
		_, err = fmt.Fprintln(out, addr)
	}

	return
}
