package k8s

import (
	"github.com/defn/dev/m/tilt/internal/k8s"
	"github.com/defn/dev/m/tilt/pkg/model"
)

type KindInfo struct {
	ImageLocators    []k8s.ImageLocator
	PodReadinessMode model.PodReadinessMode
}

func InitialKinds() map[k8s.ObjectSelector]*KindInfo {
	sel, err := k8s.NewPartialMatchObjectSelector("batch/v1", "Job", "", "")
	if err != nil {
		panic(err)
	}
	return map[k8s.ObjectSelector]*KindInfo{
		sel: {PodReadinessMode: model.PodReadinessSucceeded},
	}
}
