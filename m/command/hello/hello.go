package hello

import (
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
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

	// Set default name in viper
	viper.SetDefault("hello.name", "World")

	cmd := &cobra.Command{
		Use:   "hello [name]",
		Short: "Example hello command",
		Long:  `Example hello command - demonstrates Viper config hierarchy`,
		Args:  cobra.MaximumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			// Precedence: CLI arg > viper (env var > config file > default)
			if len(args) > 0 {
				sub.greeting = args[0]
			} else {
				sub.greeting = viper.GetString("hello.name")
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
	logger := base.CommandLogger("hello")
	logger.Info("greeting", zap.String("name", s.greeting))

	charm := base.CharmLogger()
	charm.Info("Hello", "name", s.greeting)

	return nil
}
