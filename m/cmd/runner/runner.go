package runner

import (
	"context"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"

	"github.com/defn/dev/m/cmd/base"
)

// Config holds the configuration for running the CLI
type Config struct {
	// Modules to include (e.g., root.Module, api.Module, etc.)
	Modules []fx.Option
}

// Run is the main entry point for CLI applications
func Run(cfg Config) {
	// Initialize Viper configuration
	if err := base.InitConfig(); err != nil {
		// Config initialization errors are non-fatal
		// App will run with defaults if config files don't exist
	}

	// Parse --log-level flag early (before fx.New) so fx logs use correct level

	// Check for log level in env
	log_level := "info"
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

	// Initialize fx logger at DEBUG level (separate from app logging)
	if err := base.InitFxLogger(); err != nil {
		os.Exit(1)
	}

	ctx := context.Background()

	// Build fx options
	options := []fx.Option{
		fx.WithLogger(func() fxevent.Logger {
			// Use separate fx logger at DEBUG level
			// App logger remains at configured level (default: warn)
			return &fxevent.ZapLogger{Logger: base.FxLogger()}
		}),

		fx.Invoke(func(root_cmd base.Command) error {
			// Hook into PersistentPreRun to update logger level from viper
			cobra_cmd := root_cmd.GetCommand()
			cobra_cmd.PersistentPreRun = func(cmd *cobra.Command, args []string) {
				// Update logger level with the flag/config value
				// This ensures viper-bound values take effect
				log_level := "info"
				if viper_level := viper.GetString("global.log_level"); viper_level != "" {
					log_level = viper_level
				}
				base.InitLogger(log_level) // Uses atomic level, just updates the level
			}
			return cobra_cmd.Execute()
		}),

		fx.Provide(fx.Annotate(
			func(root base.Command, subs []base.Command) base.Command {
				for _, sub_cmd := range subs {
					sub_cmd.Register(root.GetCommand())
				}

				return root
			},
			fx.ParamTags(`name:"root"`, `group:"subs"`)),
		),
	}

	// Add user-provided modules
	options = append(options, cfg.Modules...)

	app := fx.New(options...)

	if err := app.Start(ctx); err != nil {
		os.Exit(1)
	}

	if err := app.Err(); err != nil {
		os.Exit(2)
	}

	os.Exit(0)
}
