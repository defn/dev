package store

import (
	"sort"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// We call the main session the Tiltfile session, for compatibility
// with the other Session API.
const UISessionName = "Tiltfile"

// Converts EngineState into the public data model representation, a UISession.
func ToUISession(s EngineState) *v1alpha1.UISession {
	ret := &v1alpha1.UISession{
		ObjectMeta: metav1.ObjectMeta{
			Name: UISessionName,
		},
		Status: v1alpha1.UISessionStatus{},
	}

	status := &(ret.Status)
	status.RunningTiltBuild = v1alpha1.TiltBuild{
		Version:   s.TiltBuildInfo.Version,
		CommitSHA: s.TiltBuildInfo.CommitSHA,
		Dev:       s.TiltBuildInfo.Dev,
		Date:      s.TiltBuildInfo.Date,
	}
	status.SuggestedTiltVersion = s.SuggestedTiltVersion
	status.FeatureFlags = []v1alpha1.UIFeatureFlag{}
	for k, v := range s.Features {
		status.FeatureFlags = append(status.FeatureFlags, v1alpha1.UIFeatureFlag{
			Name:  k,
			Value: v,
		})
	}
	sort.Slice(status.FeatureFlags, func(i, j int) bool {
		return status.FeatureFlags[i].Name < status.FeatureFlags[j].Name
	})
	if s.FatalError != nil {
		status.FatalError = s.FatalError.Error()
	}

	status.VersionSettings = v1alpha1.VersionSettings{
		CheckUpdates: s.VersionSettings.CheckUpdates,
	}

	status.TiltStartTime = metav1.NewTime(s.TiltStartTime)

	status.TiltfileKey = s.MainTiltfilePath()

	return ret
}
