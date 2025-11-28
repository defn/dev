package main

import (
	"context"
	"os"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"

	"github.com/defn/dev/m/cmd/base"
	api "github.com/defn/dev/m/command/api"
	root "github.com/defn/dev/m/command/root"
	tui "github.com/defn/dev/m/command/tui"
)

func main() {
	ctx := context.Background()
	app := fx.New(
		fx.WithLogger(func() fxevent.Logger {
			return fxevent.NopLogger
		}),
		fx.Provide(fx.Annotate(
			func(root_cmd base.RootCommand, sub_cmds []base.SubCommand) base.RootCommand {
				for _, sub_cmd := range sub_cmds {
					sub_cmd.Register(root_cmd.GetCommand())
				}

				return root_cmd
			},
			fx.ParamTags(`name:"root"`, `group:"subs"`)),
		),
		fx.Invoke(func(root_cmd base.RootCommand) error {
			return root_cmd.GetCommand().Execute()
		}),
		root.Module,
		api.Module,
		tui.Module,
	)

	if err := app.Start(ctx); err != nil {
		os.Exit(1)
	}

	if err := app.Err(); err != nil {
		os.Exit(2)
	}

	os.Exit(0)
}
