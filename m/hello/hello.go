package main

import (
	"os"

	"github.com/bitfield/script"
)

func main() {
	// Create temporary file path
	tmp_file, err := os.CreateTemp("", "greeting-*.txt")
	if err != nil {
		script.Echo("error creating temp file").WithError(err).ExitStatus()
		os.Exit(1)
	}
	tmp_path := tmp_file.Name()
	tmp_file.Close()
	defer os.Remove(tmp_path)

	greeting := "Hello, World!"

	// Echo greeting to temporary file
	script.Echo(greeting).WriteFile(tmp_path)

	// Read from temporary file and print to screen
	script.File(tmp_path).Stdout()
}
