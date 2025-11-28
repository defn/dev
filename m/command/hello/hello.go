package hello

import (
	"os"

	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
	"go.uber.org/fx"
	"go.uber.org/zap"

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
				base.Logger().Error("failed to run hello command", zap.Error(err))
			}
		},
	}

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *subCommand) Main() error {
	logger := base.Logger().With(zap.String("cmd", "hello"))
	logger.Info("greeting", zap.String("name", s.greeting))

	charm_logger := log.New(os.Stdout)
	charm_logger.Info("Hello", "name", s.greeting)

	return nil
}
