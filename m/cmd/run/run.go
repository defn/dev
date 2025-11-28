package run

import (
	"go.uber.org/fx"

	"github.com/defn/dev/m/cmd/runner"
	"github.com/defn/dev/m/command/api"
	"github.com/defn/dev/m/command/hello"
	"github.com/defn/dev/m/command/root"
	"github.com/defn/dev/m/command/tui"
)

// Run is the main entry point, exported for testing
func Run() {
	runner.Run(runner.Config{
		Modules: []fx.Option{
			root.Module,
			api.Module,
			hello.Module,
			tui.Module,
		},
	})
}
