package root

import (
	"os"
	"os/exec"

	"github.com/spf13/cobra"
	"go.uber.org/fx"

	"github.com/defn/dev/m/cmd/base"
)

var Module = fx.Module("RootCommand",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`name:"root"`),
		),
	),
)

type rootCommand struct {
	*base.BaseRootCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.RootCommand {
	return &rootCommand{
		BaseRootCommand: base.NewRootCommand(&cobra.Command{
			Use:   "cli",
			Short: "Root command: dumps env",
			Long:  `Root command: dumps env`,
			Run: func(cmd *cobra.Command, args []string) {
				shell_cmd := exec.Command("env")
				shell_cmd.Env = append(os.Environ(), "FOO=bar")
				shell_cmd.Stdin = os.Stdin
				shell_cmd.Stdout = os.Stdout
				shell_cmd.Stderr = os.Stderr

				if err := shell_cmd.Run(); err != nil {
					return
				}
			},
		}),
	}
}
