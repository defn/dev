package manifestbuilder

import (
	"github.com/defn/dev/m/tilt/pkg/model"
)

// Assemble these targets into a manifest, that deploys to k8s,
// wiring up all the dependency ids so that the K8sTarget depends on all
// the deployed image targets
func assembleK8s(m model.Manifest, k model.K8sTarget, iTargets ...model.ImageTarget) model.Manifest {
	// images on which another image depends -- we assume they are base
	// images, i.e. not deployed directly, and so the deploy target
	// should not depend on them.
	baseImages := make(map[string]bool)
	for _, iTarget := range iTargets {
		for _, id := range iTarget.ImageMapDeps() {
			baseImages[id] = true
		}
	}

	imageMapNames := make([]string, 0, len(iTargets))
	for _, iTarget := range iTargets {
		if baseImages[iTarget.ImageMapName()] {
			continue
		}
		imageMapNames = append(imageMapNames, iTarget.ImageMapName())
	}
	k = k.WithImageDependencies(model.FilterLiveUpdateOnly(imageMapNames, iTargets))
	return m.
		WithImageTargets(iTargets).
		WithDeployTarget(k)
}

