package main

import (
	_ "embed"
	"os"

	"github.com/bitfield/script"
	"github.com/sourcegraph/conc/pool"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"
	"go.uber.org/zap"

	top "github.com/defn/dev/m"
	"github.com/defn/dev/m/cmd/base"
	"github.com/defn/dev/m/cmd/runner"
	"github.com/defn/dev/m/command/root"
	"github.com/defn/dev/m/cue"
)

//go:embed hello.cue
var hello_cue_content string

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

var Module = fx.Module("SubCommandHelloCue",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`group:"subs"`),
		),
	),
)

type SubCommand struct {
	*base.BaseCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	sub := &SubCommand{}

	viper.SetDefault("hello.greeting", "world!!")

	cmd := &cobra.Command{
		Use:   "hello [greeting]",
		Short: "Hello World command with CUE validation",
		Long:  `Hello World command - demonstrates CUE schema validation with a greeting pipeline`,
		Args:  cobra.MaximumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			// If greeting argument provided, use it with highest precedence
			if len(args) > 0 {
				viper.Set("hello.greeting", args[0])
			}
			if err := sub.Main(); err != nil {
				base.Logger().Error("failed to run hello command", zap.Error(err))
			}
		},
	}

	// Add --greeting flag
	cmd.Flags().String("greeting", "", "Greeting to use (default: world!!)")
	viper.BindPFlag("hello.greeting", cmd.Flags().Lookup("greeting"))

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *SubCommand) Main() error {
	logger := base.CommandLogger("hello_cue")
	logger.Debug("running hello_cue command")

	// First pool: Build greeting config concurrently
	p1 := pool.New().WithMaxGoroutines(3)
	var greeting_config GreetingConfig
	var greeting_err error

	p1.Go(func() {
		// Build greeting config using chained fluent builder pattern
		greeting_config, greeting_err = NewGreetingBuilder(logger).
			WithViperGreeting(viper.GetString("hello.greeting")).
			WithTransform().
			WithMergedConfig("hello.yaml").
			WithValidation(cue.NewOverlay(), top.CueModule, "github.com/defn/dev/m/hello/cue", "#Hello", hello_cue_content, top.Schema).
			Build()
	})

	// Wait for first pool (greeting pipeline) to complete
	p1.Wait()

	if greeting_err != nil {
		logger.Error("greeting pipeline failed", zap.Error(greeting_err))
		return greeting_err
	}

	// Second pool: Output and cleanup concurrently (chained after first pool)
	p2 := pool.New().WithMaxGoroutines(2)

	p2.Go(func() {
		// Output the greeting (builder has formatted it with "Hello, " prefix)
		// Use Decorate to add decoration around the greeting
		script.Echo(Decorate(greeting_config.FormattedGreeting)).Stdout()
	})

	p2.Go(func() {
		// Log completion
		logger.Info("greeting pipeline completed",
			zap.String("viper_greeting", greeting_config.ViperGreeting),
			zap.String("transformed_greeting", greeting_config.TransformedGreeting),
			zap.String("formatted_greeting", greeting_config.FormattedGreeting),
			zap.Bool("validated", greeting_config.Validated))
	})

	// Wait for second pool (output and logging) to complete
	p2.Wait()

	// Clean up merged config after all pools complete
	if greeting_config.MergedConfigPath != "" {
		os.Remove(greeting_config.MergedConfigPath)
	}

	return nil
}
