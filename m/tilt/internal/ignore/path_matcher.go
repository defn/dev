package ignore

import (
	"path/filepath"

	"github.com/bmatcuk/doublestar/v4"
	"github.com/pkg/errors"

	"github.com/defn/dev/m/tilt/internal/ospath"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// Filter out files that should not trigger new builds.
func CreateFileChangeFilter(ignores []v1alpha1.IgnoreDef) model.PathMatcher {
	return model.NewCompositeMatcher(ToMatchersBestEffort(ignores))
}

// Interpret ignores as a PathMatcher, skipping ignores that are ill-formed.
func ToMatchersBestEffort(ignores []v1alpha1.IgnoreDef) []model.PathMatcher {
	var ignoreMatchers []model.PathMatcher
	for _, ignoreDef := range ignores {
		if len(ignoreDef.Patterns) != 0 {
			m, err := NewPatternMatcher(ignoreDef.BasePath, ignoreDef.Patterns)
			if err == nil {
				ignoreMatchers = append(ignoreMatchers, m)
			}
		} else {
			m, err := NewDirectoryMatcher(ignoreDef.BasePath)
			if err == nil {
				ignoreMatchers = append(ignoreMatchers, m)
			}
		}
	}
	return ignoreMatchers
}

// PatternMatcher matches files using glob patterns.
type PatternMatcher struct {
	basePath string
	patterns []string
}

func NewPatternMatcher(basePath string, patterns []string) (*PatternMatcher, error) {
	absPath, err := filepath.Abs(basePath)
	if err != nil {
		return nil, errors.Wrapf(err, "failed to get abs path of '%s'", basePath)
	}
	return &PatternMatcher{
		basePath: absPath,
		patterns: patterns,
	}, nil
}

func (m *PatternMatcher) Matches(f string) (bool, error) {
	// Make path relative to base if possible
	relPath := f
	if filepath.IsAbs(f) {
		rel, err := filepath.Rel(m.basePath, f)
		if err == nil && !filepath.IsAbs(rel) {
			relPath = rel
		}
	}

	for _, pattern := range m.patterns {
		matched, err := doublestar.Match(pattern, relPath)
		if err != nil {
			continue
		}
		if matched {
			return true, nil
		}
		// Also try matching just the base name
		matched, err = doublestar.Match(pattern, filepath.Base(f))
		if err != nil {
			continue
		}
		if matched {
			return true, nil
		}
	}
	return false, nil
}

func (m *PatternMatcher) MatchesEntireDir(f string) (bool, error) {
	// For simplicity, we never skip entire directories
	return false, nil
}

// DirectoryMatcher matches all files in a directory.
type DirectoryMatcher struct {
	dir string
}

var _ model.PathMatcher = DirectoryMatcher{}

func NewDirectoryMatcher(dir string) (DirectoryMatcher, error) {
	dir, err := filepath.Abs(dir)
	if err != nil {
		return DirectoryMatcher{}, errors.Wrapf(err, "failed to get abs path of '%s'", dir)
	}
	return DirectoryMatcher{dir}, nil
}

func (d DirectoryMatcher) Dir() string {
	return d.dir
}

func (d DirectoryMatcher) Matches(p string) (bool, error) {
	return ospath.IsChild(d.dir, p), nil
}

func (d DirectoryMatcher) MatchesEntireDir(p string) (bool, error) {
	return d.Matches(p)
}
