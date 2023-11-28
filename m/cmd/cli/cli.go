package main

import (
	root "github.com/defn/dev/m/command/root"
	_ "github.com/defn/dev/m/command/api"
	_ "github.com/defn/dev/m/command/tui"
	_ "github.com/defn/dev/m/command/infra"
)

func main() {
	root.Execute()
}
