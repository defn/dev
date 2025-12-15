package auth

import (
	"context"
	"fmt"

	"github.com/spf13/cobra"

	"github.com/defn/dev/m/flyctl/iostreams"

	"github.com/defn/dev/m/flyctl/internal/command"
	"github.com/defn/dev/m/flyctl/internal/config"
	"github.com/defn/dev/m/flyctl/internal/flag"
	"github.com/defn/dev/m/flyctl/internal/flyutil"
	"github.com/defn/dev/m/flyctl/internal/render"
)

func newWhoAmI() *cobra.Command {
	const (
		long = `Displays the users email address/service identity currently
authenticated and in use.
`
		short = "Show the currently authenticated user"
	)

	cmd := command.New("whoami", long, short, runWhoAmI,
		command.RequireSession)
	flag.Add(cmd, flag.JSONOutput())
	return cmd
}

func runWhoAmI(ctx context.Context) error {
	client := flyutil.ClientFromContext(ctx)

	user, err := client.GetCurrentUser(ctx)
	if err != nil {
		return fmt.Errorf("failed retrieving current user: %w", err)
	}

	io := iostreams.FromContext(ctx)
	cfg := config.FromContext(ctx)

	if cfg.JSONOutput {
		_ = render.JSON(io.Out, map[string]string{"email": user.Email})
	} else {
		fmt.Fprintln(io.Out, user.Email)
	}

	return nil
}
