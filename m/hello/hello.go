package main

import (
	_ "embed"
	"os"

	"github.com/bitfield/script"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"
	"go.uber.org/zap"
	"gopkg.in/yaml.v3"

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

	viper.SetDefault("hello.greeting", "world!!")

	cmd := &cobra.Command{
		Use:   "hello [greeting]",
		Short: "Hello World command using script pipeline",
		Long:  `Hello World command - demonstrates script-based greeting`,
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

func (s *subCommand) Main() error {
	logger := base.CommandLogger("hello")
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

	greeting := viper.GetString("hello.greeting")
	formatted_greeting := "Hello, " + greeting

	// Echo greeting to temporary file
	script.Echo(formatted_greeting).WriteFile(tmp_path)

	// Read from temporary file and print to screen
	script.File(tmp_path).Stdout()

	// Validate hello.yaml merged with viper config
	merged_config_path, err := mergeConfigWithViper("hello.yaml")
	if err != nil {
		logger.Error("failed to merge config with viper", zap.Error(err))
		return err
	}
	defer os.Remove(merged_config_path)

	if err = cue.NewOverlay().ValidateConfig(
		top.CueModule,                 // module: CUE module definition
		"github.com/defn/dev/m/hello", // package_name: package for this module
		merged_config_path,            // config_file_path: merged config
		"#Hello",                      // schema_label: the "#Hello" definition
		hello_cue_content,             // config: CUE schema content from hello.cue
		top.Schema,                    // schema_files
	); err != nil {
		logger.Error("config validation failed", zap.Error(err))
		return err
	}

	return nil
}

// mergeConfigWithViper reads a YAML config file, merges it with viper settings,
// and returns the path to a temporary file containing the merged configuration
func mergeConfigWithViper(config_path string) (string, error) {
	// Read the YAML config file
	config_data, err := os.ReadFile(config_path)
	if err != nil {
		return "", err
	}

	// Parse YAML into a map
	var config_map map[string]interface{}
	if err := yaml.Unmarshal(config_data, &config_map); err != nil {
		return "", err
	}

	// Add greeting from viper if not present in YAML
	if _, exists := config_map["greeting"]; !exists {
		config_map["greeting"] = viper.GetString("hello.greeting")
	}

	// Marshal back to YAML
	merged_data, err := yaml.Marshal(config_map)
	if err != nil {
		return "", err
	}

	// Write to temporary file
	tmp_file, err := os.CreateTemp("", "hello-config-*.yaml")
	if err != nil {
		return "", err
	}
	defer tmp_file.Close()

	if _, err := tmp_file.Write(merged_data); err != nil {
		os.Remove(tmp_file.Name())
		return "", err
	}

	return tmp_file.Name(), nil
}
