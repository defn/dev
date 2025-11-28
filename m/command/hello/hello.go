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
	*base.BaseCommand
	greeting string
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	sub := &subCommand{}

	cmd := &cobra.Command{
		Use:   "hello [name]",
		Short: "Example hello command",
		Long:  `Example hello command - simple copy-paste template`,
		Args:  cobra.MaximumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			if len(args) > 0 {
				sub.greeting = args[0]
			} else {
				sub.greeting = "World"
			}
			if err := sub.Main(); err != nil {
				fmt.Printf("Error: %v\n", err)
			}
		},
	}

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *subCommand) Main() error {
	fmt.Printf("Hello, %s!\n", s.greeting)
	return nil
}
