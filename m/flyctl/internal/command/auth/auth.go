// Package auth implements the auth command chain.
package auth

import (
	"github.com/spf13/cobra"

	"github.com/defn/dev/m/flyctl/internal/command"
)

// New initializes and returns a new auth Command.
func New() *cobra.Command {
	const (
		long  = `Authenticate with Fly (and logout if you need to).`
		short = "Manage authentication"
	)

	auth := command.New("auth", short, long, nil)

	auth.AddCommand(
		newWhoAmI(),
		newToken(),
		newLogin(),
		newLogout(),
	)

	return auth
}
