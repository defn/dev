package main

import (
	root "github.com/defn/dev/m/command/root"

	_ "github.com/defn/dev/m/command/api"
	_ "github.com/defn/dev/m/command/infra"
	_ "github.com/defn/dev/m/command/tui"
)

// bump 1

func main() {
	root.Execute()
}
