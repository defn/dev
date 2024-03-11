package main

import (
	_ "embed"

	tf "github.com/defn/dev/m/tf"
)

//go:embed schema.cue
var schema string

func init() {
	tf.Init(schema)
}

func main() {
	tf.Execute()
}
