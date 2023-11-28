package main

import (
	_ "github.com/defn/dev/m/command/api"
	_ "github.com/defn/dev/m/command/dev"
	_ "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"
	_ "github.com/defn/dev/m/command/tui"
)

func main() {
	root.Execute()
}
