package manifestutils

import (
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// NewManifestTarget creates a new ManifestTarget for testing.
func NewManifestTarget(m model.Manifest) *store.ManifestTarget {
	return store.NewManifestTarget(m)
}
