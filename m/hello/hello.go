package main

import (
	"os"

	"github.com/bitfield/script"
	"github.com/spf13/cobra"
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/defn/dev/m/cmd/base"
	"github.com/defn/dev/m/cmd/runner"
	"github.com/defn/dev/m/command/root"
)

func run() {
	runner.Run(runner.Config{
		Modules: []fx.Option{
			root.Module,
			Module,
		},
	})
}

func main() {
	run()
}

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
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	sub := &subCommand{}

	cmd := &cobra.Command{
		Use:   "hello",
		Short: "Hello World command using script pipeline",
		Long:  `Hello World command - demonstrates script-based greeting`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
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
	logger.Debug("running hello command")

	// Create temporary file path
	tmp_file, err := os.CreateTemp("", "greeting-*.txt")
	if err != nil {
		script.Echo("error creating temp file").WithError(err).ExitStatus()
		return err
	}
	tmp_path := tmp_file.Name()
	tmp_file.Close()
	defer os.Remove(tmp_path)

	greeting := "Hello, World!"

	// Echo greeting to temporary file
	script.Echo(greeting).WriteFile(tmp_path)

	// Read from temporary file and print to screen
	script.File(tmp_path).Stdout()

	return nil
}
