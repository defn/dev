package model

import (
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// ManifestName is a unique identifier for a manifest (resource).
type ManifestName string

func (m ManifestName) String() string { return string(m) }

func (m ManifestName) TargetID() TargetID {
	return TargetID{
		Type: TargetTypeConfigs,
		Name: TargetName(m),
	}
}

// The Tiltfile is a special manifest for the Tiltfile itself.
const MainTiltfileManifestName = ManifestName("(Tiltfile)")

// ManifestNameSet is a set of manifest names.
type ManifestNameSet map[ManifestName]bool

// Manifest represents a resource that Tilt manages.
type Manifest struct {
	Name ManifestName

	// Configuration for the local_resource
	localTarget LocalTarget

	// The trigger mode for this manifest.
	TriggerMode TriggerMode

	// Labels for this manifest.
	Labels map[string]string

	// ResourceDependencies lists manifest names that this manifest depends on.
	ResourceDependencies []ManifestName

	// The source of disable state for this manifest.
	DisableSource *v1alpha1.DisableSource
}

var _ TargetSpec = Manifest{}

func (m Manifest) ID() TargetID {
	return TargetID{
		Type: TargetTypeManifest,
		Name: TargetName(m.Name),
	}
}

func (m Manifest) DependencyIDs() []TargetID {
	result := []TargetID{}
	if !m.localTarget.Empty() {
		result = append(result, m.localTarget.ID())
	}
	return result
}

func (m Manifest) Validate() error {
	if !m.localTarget.Empty() {
		err := m.localTarget.Validate()
		if err != nil {
			return err
		}
	}
	return nil
}

// TargetSpecs returns all the target specs associated with this manifest.
func (m Manifest) TargetSpecs() []TargetSpec {
	result := []TargetSpec{}
	if !m.localTarget.Empty() {
		result = append(result, m.localTarget)
	}
	return result
}

func (m Manifest) IsLocal() bool {
	return !m.localTarget.Empty()
}

func (m Manifest) LocalTarget() LocalTarget {
	return m.localTarget
}

func (m Manifest) WithLocalTarget(lt LocalTarget) Manifest {
	m.localTarget = lt
	return m
}

func (m Manifest) WithDisableSource(ds *v1alpha1.DisableSource) Manifest {
	m.DisableSource = ds
	return m
}

func (m Manifest) WithLabels(labels map[string]string) Manifest {
	m.Labels = labels
	return m
}

// LocalPaths returns the local file paths that this manifest depends on.
func (m Manifest) LocalPaths() []string {
	if !m.localTarget.Empty() {
		return m.localTarget.Dependencies()
	}
	return nil
}
