package tokens

import (
	"github.com/defn/dev/m/flyctl/internal/command"
	"github.com/spf13/cobra"
)

func New() *cobra.Command {
	const (
		short = "Manage Fly.io API tokens"
		long  = "Manage Fly.io API tokens"
		usage = "tokens"
	)

	cmd := command.New(usage, short, long, nil)

	cmd.AddCommand(
		newRevoke(),
		newDebug(),
	)

	return cmd
}
