package main

import (
	"context"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"

	"github.com/defn/dev/m/cmd/base"
	"github.com/defn/dev/m/command/api"
	"github.com/defn/dev/m/command/hello"
	"github.com/defn/dev/m/command/root"
	"github.com/defn/dev/m/command/tui"
)

func main() {
	// Initialize Viper configuration
	if err := base.InitConfig(); err != nil {
		// Config initialization errors are non-fatal
		// App will run with defaults if config files don't exist
	}

	// Parse --log-level flag early (before fx.New) so fx logs use correct level
	log_level := "warn"
	if level := os.Getenv("DEFN_GLOBAL_LOG_LEVEL"); level != "" {
		log_level = level
	}
	// Check for --log-level flag in os.Args
	for i, arg := range os.Args {
		if arg == "--log-level" && i+1 < len(os.Args) {
			log_level = os.Args[i+1]
			break
		} else if len(arg) > 12 && arg[:12] == "--log-level=" {
			log_level = arg[12:]
			break
		}
	}
	if err := base.InitLogger(log_level); err != nil {
		os.Exit(1)
	}

	ctx := context.Background()
	app := fx.New(
		fx.WithLogger(func() fxevent.Logger {
			// Use zap logger for fx with atomic level
			// Level can be changed dynamically via --log-level flag
			return &fxevent.ZapLogger{Logger: base.Logger()}
		}),

		root.Module,
		fx.Invoke(func(root_cmd base.Command) error {
			// Hook into PersistentPreRun to update logger level from viper
			cobra_cmd := root_cmd.GetCommand()
			cobra_cmd.PersistentPreRun = func(cmd *cobra.Command, args []string) {
				// Update logger level with the flag/config value
				// This ensures viper-bound values take effect
				log_level := "warn"
				if viper_level := viper.GetString("global.log_level"); viper_level != "" {
					log_level = viper_level
				}
				base.InitLogger(log_level) // Uses atomic level, just updates the level
			}
			return cobra_cmd.Execute()
		}),

		api.Module,
		hello.Module,
		tui.Module,
		fx.Provide(fx.Annotate(
			func(root base.Command, subs []base.Command) base.Command {
				for _, sub_cmd := range subs {
					sub_cmd.Register(root.GetCommand())
				}

				return root
			},
			fx.ParamTags(`name:"root"`, `group:"subs"`)),
		),
	)

	if err := app.Start(ctx); err != nil {
		os.Exit(1)
	}

	if err := app.Err(); err != nil {
		os.Exit(2)
	}

	os.Exit(0)
}
