package dockerimage

import (
	"fmt"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"

	"github.com/defn/dev/m/tilt/internal/container"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
)

// A helper function for updating the imagemap
// from dockerimage.Reconciler and cmdimage.Reconciler.
// This is mainly for easing the transition to reconcilers.
func UpdateImageMap(
	iTarget model.ImageTarget,
	cluster *v1alpha1.Cluster,
	imageMaps map[types.NamespacedName]*v1alpha1.ImageMap,
	startTime *metav1.MicroTime,
	taggedRefs container.TaggedRefs,
) (store.ImageBuildResult, error) {
	result := store.NewImageBuildResult(iTarget.ID(), taggedRefs.LocalRef, taggedRefs.ClusterRef)

	result.ImageMapStatus.BuildStartTime = startTime
	nn := types.NamespacedName{Name: iTarget.ImageMapName()}
	im, ok := imageMaps[nn]
	if !ok {
		return store.ImageBuildResult{}, fmt.Errorf("apiserver missing ImageMap: %s", iTarget.ID().Name)
	}
	im.Status = result.ImageMapStatus
	return result, nil
}
