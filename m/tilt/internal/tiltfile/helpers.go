package tiltfile

import (
	"fmt"
	"os"
	"path/filepath"

	"go.starlark.net/starlark"

	"github.com/defn/dev/m/tilt/internal/tiltfile/value"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// parseValuesToStrings converts a starlark value (string or list of strings) to []string
func parseValuesToStrings(v starlark.Value, name string) ([]string, error) {
	values := value.ValueOrSequenceToSlice(v)
	result := make([]string, 0, len(values))
	for _, val := range values {
		s, ok := starlark.AsString(val)
		if !ok {
			return nil, fmt.Errorf("%s must be a string or list of strings; got %T", name, val)
		}
		result = append(result, s)
	}
	return result, nil
}

// checkResourceConflict checks if a resource with the given name already exists
func (s *tiltfileState) checkResourceConflict(name string) error {
	if _, ok := s.localByName[name]; ok {
		return fmt.Errorf("resource %q already defined", name)
	}
	return nil
}

// extractSecrets extracts secrets from the tiltfile state
func (s *tiltfileState) extractSecrets() model.SecretSet {
	// In the simplified version, we don't have secrets from K8s YAML
	// Return empty secret set
	return model.SecretSet{}
}

// findGitRoot walks up from path looking for a .git directory
func findGitRoot(path string) string {
	path, err := filepath.Abs(path)
	if err != nil {
		return ""
	}
	for {
		gitPath := filepath.Join(path, ".git")
		if _, err := os.Stat(gitPath); err == nil {
			return path
		}
		parent := filepath.Dir(path)
		if parent == path {
			return ""
		}
		path = parent
	}
}

// repoIgnoresForPaths returns ignore definitions for git repos containing the paths
func repoIgnoresForPaths(paths []string) []v1alpha1.IgnoreDef {
	reposFound := map[string]bool{}
	var ignores []v1alpha1.IgnoreDef

	for _, path := range paths {
		repoRoot := findGitRoot(path)
		if repoRoot != "" && !reposFound[repoRoot] {
			reposFound[repoRoot] = true
			ignores = append(ignores, v1alpha1.IgnoreDef{
				BasePath: repoRoot,
				Patterns: []string{".git"},
			})
		}
	}

	return ignores
}
