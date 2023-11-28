package main

import (
	"fmt"

	root "github.com/defn/dev/m/command/root"
	_ "github.com/defn/dev/m/command/api"
	_ "github.com/defn/dev/m/command/tui"
	_ "github.com/defn/dev/m/command/infra"
)

func main() {
	fmt.Println("================================================================")
	fmt.Println(" starting")
	fmt.Println("================================================================")
	root.Execute()
}
