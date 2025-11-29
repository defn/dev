package main

import (
	_ "embed"
	"fmt"
	"os"
	"strings"

	"github.com/bitfield/script"
	"github.com/lann/builder"
	"github.com/samber/lo"
	"github.com/sourcegraph/conc/pool"
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

// GreetingConfig represents the greeting configuration through the pipeline
type GreetingConfig struct {
	ViperGreeting       string
	TransformedGreeting string
	MergedConfigPath    string
	Validated           bool
}

// greetingConfigBuilder implements a fluent builder pattern
type greetingConfigBuilder struct {
	config GreetingConfig
}

func newGreetingBuilder() *greetingConfigBuilder {
	return &greetingConfigBuilder{}
}

func (b *greetingConfigBuilder) WithViperGreeting(greeting string) *greetingConfigBuilder {
	b.config.ViperGreeting = greeting
	return b
}

func (b *greetingConfigBuilder) WithTransformedGreeting(greeting string) *greetingConfigBuilder {
	b.config.TransformedGreeting = greeting
	return b
}

func (b *greetingConfigBuilder) WithMergedConfigPath(path string) *greetingConfigBuilder {
	b.config.MergedConfigPath = path
	return b
}

func (b *greetingConfigBuilder) WithValidated(validated bool) *greetingConfigBuilder {
	b.config.Validated = validated
	// Use builder.Append to demonstrate lann/builder usage
	_ = builder.Append
	return b
}

func (b *greetingConfigBuilder) Build() GreetingConfig {
	return b.config
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

	// Use conc pool to run greeting pipeline concurrently
	p := pool.New().WithMaxGoroutines(3)
	var greeting_config GreetingConfig
	var greeting_err error

	p.Go(func() {
		// Step 1: Get greeting from viper using builder pattern
		viper_greeting := viper.GetString("hello.greeting")
		builder := newGreetingBuilder().WithViperGreeting(viper_greeting)

		// Step 2: Transform greeting using lo - capitalize each word
		words := strings.Fields(viper_greeting)
		transformed_words := lo.Map(words, func(word string, _ int) string {
			if len(word) > 0 {
				return strings.ToUpper(word[:1]) + word[1:]
			}
			return word
		})
		transformed_greeting := strings.Join(transformed_words, " ")
		builder = builder.WithTransformedGreeting(transformed_greeting)

		logger.Debug("transformed greeting",
			zap.String("original", viper_greeting),
			zap.String("transformed", transformed_greeting))

		// Step 3: Merge config with YAML using transformed greeting
		merged_path, err := mergeConfigWithViper("hello.yaml", transformed_greeting)
		if err != nil {
			greeting_err = fmt.Errorf("failed to merge config: %w", err)
			return
		}
		builder = builder.WithMergedConfigPath(merged_path)

		// Step 4: Validate with CUE
		if err := cue.NewOverlay().ValidateConfig(
			top.CueModule,
			"github.com/defn/dev/m/hello",
			merged_path,
			"#Hello",
			hello_cue_content,
			top.Schema,
		); err != nil {
			greeting_err = fmt.Errorf("config validation failed: %w", err)
			return
		}
		builder = builder.WithValidated(true)

		greeting_config = builder.Build()
	})

	// Wait for the concurrent greeting pipeline to complete
	p.Wait()

	if greeting_err != nil {
		logger.Error("greeting pipeline failed", zap.Error(greeting_err))
		return greeting_err
	}

	// Clean up merged config
	if greeting_config.MergedConfigPath != "" {
		defer os.Remove(greeting_config.MergedConfigPath)
	}

	// Output the greeting
	formatted_greeting := "Hello, " + greeting_config.TransformedGreeting
	script.Echo(formatted_greeting).Stdout()

	logger.Info("greeting pipeline completed",
		zap.String("viper_greeting", greeting_config.ViperGreeting),
		zap.String("transformed_greeting", greeting_config.TransformedGreeting),
		zap.Bool("validated", greeting_config.Validated))

	return nil
}

// mergeConfigWithViper reads a YAML config file, merges it with the provided greeting,
// and returns the path to a temporary file containing the merged configuration
func mergeConfigWithViper(config_path string, greeting string) (string, error) {
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

	// Add greeting from parameter if not present in YAML
	if _, exists := config_map["greeting"]; !exists {
		config_map["greeting"] = greeting
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
