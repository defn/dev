package main

import (
	"embed"
	"fmt"

	"go.uber.org/fx"
)

//go:embed cue/*
var defn_dev_use embed.FS

func main() {
	fx.New(
		fx.Provide(UseStudentRepository),

		fx.Invoke(func(cr CueRepository) {
			u := cr.VendCueConfig()
			ctx := u.GetContext()
			val, _ := BuildValueFromOverlay(ctx, defn_dev_use, "/cue")
			fmt.Printf("%s\n", val)
		}),
	).Run()
}
