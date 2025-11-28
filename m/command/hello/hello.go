package hello

import (
	"fmt"

	"github.com/spf13/cobra"
	"go.uber.org/fx"

	"github.com/defn/dev/m/cmd/base"
)

var Module = fx.Module("SubCommandHello",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`group:"subs"`),
		),
	),
)

type subCommand struct {
	*base.BaseSubCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.SubCommand {
	return &subCommand{
		BaseSubCommand: base.NewSubCommand(&cobra.Command{
			Use:   "hello [name]",
			Short: "Example hello command",
			Long:  `Example hello command - simple copy-paste template`,
			Args:  cobra.MaximumNArgs(1),
			Run: func(cmd *cobra.Command, args []string) {
				if len(args) > 0 {
					fmt.Printf("Hello, %s!\n", args[0])
				} else {
					fmt.Println("Hello, World!")
				}
			},
		}),
	}
}
