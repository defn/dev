package cli

import (
	"context"

	"github.com/spf13/cobra"

	"github.com/defn/dev/m/tilt/pkg/model"
)

type verifyInstallCmd struct {
}

func (c *verifyInstallCmd) name() model.TiltSubcommand { return "verify-install" }

func (c *verifyInstallCmd) register() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "verify-install",
		Short: "Verifies Tilt Installation",
	}
	return cmd
}

func (c *verifyInstallCmd) run(ctx context.Context, args []string) error {
	return nil
}
