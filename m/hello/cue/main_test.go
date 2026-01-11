package main

import (
	"os"
	"testing"

	"github.com/rogpeppe/go-internal/testscript"
)

func TestMain(m *testing.M) {
	testscript.Main(m, map[string]func(){
		"hello_cue": run,
	})
}

func TestHelloCueCommand(t *testing.T) {
	// Skip if testdata directory doesn't exist or is empty
	if _, err := os.Stat("testdata"); os.IsNotExist(err) {
		t.Skip("testdata directory not found")
	}
	testscript.Run(t, testscript.Params{
		Dir:                 "testdata",
		RequireExplicitExec: true,
	})
}
