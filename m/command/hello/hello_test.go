package hello_test

import (
	"testing"

	"github.com/rogpeppe/go-internal/testscript"

	"github.com/defn/dev/m/cmd/run"
)

func TestMain(m *testing.M) {
	// Use the main binary's Run function for testscript
	testscript.Main(m, map[string]func(){
		"defn": run.Run,
	})
}

func TestHelloCommand(t *testing.T) {
	testscript.Run(t, testscript.Params{
		Dir:                 "testdata",
		RequireExplicitExec: true,
	})
}
