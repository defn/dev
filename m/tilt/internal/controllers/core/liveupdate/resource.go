package liveupdate

import (
	"time"

	"github.com/defn/dev/m/tilt/internal/controllers/apis/liveupdate"
	"github.com/defn/dev/m/tilt/internal/store/k8sconv"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// Helper interface for live-updating different kinds of resources.
//
// This interface uses the language "pods", even though only Kubernetes
// has pods. For other kinds of orchestrator, just use whatever kind
// of workload primitive fits best.
type luResource interface {
	// The time to start syncing changes from.
	bestStartTime() time.Time

	// An iterator for visiting each container.
	visitSelectedContainers(visit func(pod v1alpha1.Pod, c v1alpha1.Container) bool)
}

type luK8sResource struct {
	selector *v1alpha1.LiveUpdateKubernetesSelector
	res      *k8sconv.KubernetesResource
	im       *v1alpha1.ImageMap
}

func (r *luK8sResource) bestStartTime() time.Time {
	if r.res.ApplyStatus != nil {
		return r.res.ApplyStatus.LastApplyStartTime.Time
	}

	startTime := time.Time{}
	for _, pod := range r.res.FilteredPods {
		if startTime.IsZero() || (!pod.CreatedAt.IsZero() && pod.CreatedAt.Time.Before(startTime)) {
			startTime = pod.CreatedAt.Time
		}
	}
	return startTime
}

// Visit all selected containers.
func (r *luK8sResource) visitSelectedContainers(
	visit func(pod v1alpha1.Pod, c v1alpha1.Container) bool) {
	for _, pod := range r.res.FilteredPods {
		for _, c := range pod.Containers {
			if c.Name == "" {
				// ignore any blatantly invalid containers
				continue
			}
			if !liveupdate.KubernetesSelectorMatchesContainer(c, r.selector, r.im) {
				continue
			}
			stop := visit(pod, c)
			if stop {
				return
			}
		}
	}
}

