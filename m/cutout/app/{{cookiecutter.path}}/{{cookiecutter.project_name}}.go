package main

import (
	"fmt"

	_ "github.com/defn/dev/m/command/api"
	_ "github.com/defn/dev/m/command/dev"
	_ "github.com/defn/dev/m/command/infra"
	root "github.com/defn/dev/m/command/root"
	_ "github.com/defn/dev/m/command/tui"
)

func main() {
	fmt.Println("================================================================")
	fmt.Println(" starting")
	fmt.Println("================================================================")
	root.Execute()
}
