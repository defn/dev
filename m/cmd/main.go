package main

import (
	"context"
	"os"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"

	"github.com/defn/dev/m/cmd/base"
	"github.com/defn/dev/m/command/api"
	"github.com/defn/dev/m/command/root"
	"github.com/defn/dev/m/command/tui"
)

func main() {
	ctx := context.Background()
	app := fx.New(
		fx.WithLogger(func() fxevent.Logger {
			return fxevent.NopLogger
		}),

		root.Module,
		fx.Invoke(func(root_cmd base.RootCommand) error {
			return root_cmd.GetCommand().Execute()
		}),

		api.Module,
		tui.Module,
		fx.Provide(fx.Annotate(
			func(root base.RootCommand, subs []base.SubCommand) base.RootCommand {
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
