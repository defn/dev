package hello_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/rogpeppe/go-internal/testscript"
)

func TestMain(m *testing.M) {
	os.Exit(testscript.RunMain(m, map[string]func() int{
		// defn binary will be provided via testscript.Params
	}))
}

func TestHelloCommand(t *testing.T) {
	// Find the defn binary built by bazel
	defn_binary := os.Getenv("DEFN_BINARY")
	if defn_binary == "" {
		// Try to find it in the standard bazel output location
		defn_binary = filepath.Join("..", "..", "bazel-bin", "cmd", "cmd_", "cmd")
		if _, err := os.Stat(defn_binary); err != nil {
			t.Skip("defn binary not found, run 'b build' first")
		}
	}

	testscript.Run(t, testscript.Params{
		Dir: "testdata",
		Setup: func(env *testscript.Env) error {
			// Make defn binary available in test PATH
			env.Vars = append(env.Vars, "PATH="+filepath.Dir(defn_binary)+":"+os.Getenv("PATH"))
			// Symlink defn binary so testscript can find it
			defn_link := filepath.Join(env.WorkDir, ".bin", "defn")
			os.MkdirAll(filepath.Dir(defn_link), 0755)
			os.Symlink(defn_binary, defn_link)
			env.Vars = append(env.Vars, "PATH="+filepath.Join(env.WorkDir, ".bin")+":"+os.Getenv("PATH"))
			return nil
		},
	})
}
