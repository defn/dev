package main

import (
	_ "embed"

	root "github.com/defn/dev/m/command/root"
	tf "github.com/defn/dev/m/tf"
)

//go:embed schema.cue
var schema string

func init() {
	tf.Init(schema)
}

func main() {
	root.Execute()
}
