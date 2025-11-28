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
	*base.BaseCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	root := &rootCommand{}

	cmd := &cobra.Command{
		Use:   "defn",
		Short: "Root command: dumps env",
		Long:  `Root command: dumps env`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			if err := root.Main(); err != nil {
				return
			}
		},
	}

	root.BaseCommand = base.NewCommand(cmd)
	return root
}

func (r *rootCommand) Main() error {
	shell_cmd := exec.Command("env")
	shell_cmd.Env = append(os.Environ(), "FOO=bar")
	shell_cmd.Stdin = os.Stdin
	shell_cmd.Stdout = os.Stdout
	shell_cmd.Stderr = os.Stderr

	return shell_cmd.Run()
}
