package main

import (
	_ "embed"
	"os"

	"github.com/bitfield/script"
	"github.com/spf13/cobra"
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
	logger := base.CommandLogger("hello")
	logger.Debug("running hello command")

	if err := validateHelloConfig(); err != nil {
		logger.Error("config validation failed", zap.Error(err))
		return err
	}

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

func validateHelloConfig() error {
	// This mimics: cue vet hello.cue hello.yaml -d '#Hello'
	overlay := cue.NewOverlay()
	return overlay.ValidateConfig(
		top.CueModule,                 // module: CUE module definition
		"github.com/defn/dev/m/hello", // package_name: package for this module
		"hello.yaml",                  // config_file_path: path to hello.yaml
		"#Hello",                      // schema_label: the "#Hello" definition
		hello_cue_content,             // config: CUE schema content from hello.cue
		top.Schema,                    // schema_files
	)
}
