package config

import (
	"github.com/spf13/cobra"

	"github.com/defn/dev/m/flyctl/internal/command"
)

// New initializes and returns a new config Command.
func New() (cmd *cobra.Command) {
	const (
		short = "Manage an app's configuration"
		long  = `The CONFIG commands allow you to work with an application's configuration.`
	)
	cmd = command.New("config", short, long, nil)

	// Subcommands removed - config is primarily used for token management now
	return
}
