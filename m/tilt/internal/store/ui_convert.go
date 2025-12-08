package store

import (
	"sort"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
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
	status.NeedsAnalyticsNudge = false // Analytics removed
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

// Converts an EngineState into a list of UIResources.
// The order of the list is non-deterministic.
func ToUIResourceList(state EngineState, disableSources map[string][]v1alpha1.DisableSource) ([]*v1alpha1.UIResource, error) {
	ret := make([]*v1alpha1.UIResource, 0, len(state.ManifestTargets)+1)

	// All tiltfiles appear earlier than other resources in the same group.
	for _, name := range state.TiltfileDefinitionOrder {
		ms, ok := state.TiltfileStates[name]
		if !ok {
			continue
		}

		r := TiltfileResource(name, ms)
		r.Status.Order = int32(len(ret) + 1)
		ret = append(ret, r)
	}

	for _, mt := range state.Targets() {
		mn := mt.Manifest.Name
		r := toUIResource(mt, state, disableSources[mn.String()])

		r.Status.Order = int32(len(ret) + 1)
		ret = append(ret, r)
	}

	return ret, nil
}

// TiltfileResource creates a UIResource for a Tiltfile
func TiltfileResource(name model.ManifestName, ms *ManifestState) *v1alpha1.UIResource {
	ltfb := ms.LastBuild()
	ctfb := ms.EarliestCurrentBuild()

	pctfb := toBuildRunning(ctfb)
	history := []v1alpha1.UIBuildTerminated{}
	if !ltfb.Empty() {
		history = append(history, toBuildTerminated(ltfb))
	}
	tr := &v1alpha1.UIResource{
		ObjectMeta: metav1.ObjectMeta{
			Name: string(name),
		},
		Status: v1alpha1.UIResourceStatus{
			CurrentBuild:  pctfb,
			BuildHistory:  history,
			RuntimeStatus: v1alpha1.RuntimeStatusNotApplicable,
			UpdateStatus:  ms.UpdateStatus(model.TriggerModeAuto),
		},
	}
	start := metav1.NewMicroTime(ctfb.StartTime)
	finish := metav1.NewMicroTime(ltfb.FinishTime)
	if !ctfb.Empty() {
		tr.Status.PendingBuildSince = start
	} else {
		tr.Status.LastDeployTime = finish
	}

	return tr
}

func toUIResource(mt *ManifestTarget, s EngineState, disableSources []v1alpha1.DisableSource) *v1alpha1.UIResource {
	mn := mt.Manifest.Name
	ms := mt.State
	endpoints := ManifestTargetEndpoints(mt)

	bh := toBuildsTerminated(ms.BuildHistory)
	lastDeploy := metav1.NewMicroTime(ms.LastSuccessfulDeployTime)
	currentBuild := ms.EarliestCurrentBuild()
	cb := toBuildRunning(currentBuild)

	hasPendingChanges, pendingBuildSince := ms.HasPendingChanges()

	r := &v1alpha1.UIResource{
		ObjectMeta: metav1.ObjectMeta{
			Name:   mn.String(),
			Labels: mt.Manifest.Labels,
		},
		Status: v1alpha1.UIResourceStatus{
			LastDeployTime:    lastDeploy,
			BuildHistory:      bh,
			PendingBuildSince: metav1.NewMicroTime(pendingBuildSince),
			CurrentBuild:      cb,
			EndpointLinks:     toAPILinks(endpoints),
			TriggerMode:       int32(mt.Manifest.TriggerMode),
			HasPendingChanges: hasPendingChanges,
			Queued:            s.ManifestInTriggerQueue(mn),
		},
	}

	// Populate update and runtime status
	r.Status.UpdateStatus = mt.UpdateStatus()
	r.Status.RuntimeStatus = mt.RuntimeStatus()

	if mt.Manifest.IsLocal() {
		lState := mt.State.LocalRuntimeState()
		r.Status.LocalResourceInfo = &v1alpha1.UIResourceLocal{PID: int64(lState.PID)}
	}

	return r
}

func toBuildRunning(br model.BuildRecord) *v1alpha1.UIBuildRunning {
	if br.Empty() {
		return nil
	}

	return &v1alpha1.UIBuildRunning{
		StartTime: metav1.NewMicroTime(br.StartTime),
		SpanID:    string(br.SpanID),
	}
}

func toBuildTerminated(br model.BuildRecord) v1alpha1.UIBuildTerminated {
	e := ""
	if br.Error != nil {
		e = br.Error.Error()
	}

	return v1alpha1.UIBuildTerminated{
		Error:      e,
		StartTime:  metav1.NewMicroTime(br.StartTime),
		FinishTime: metav1.NewMicroTime(br.FinishTime),
		SpanID:     string(br.SpanID),
	}
}

func toBuildsTerminated(brs []model.BuildRecord) []v1alpha1.UIBuildTerminated {
	ret := make([]v1alpha1.UIBuildTerminated, len(brs))
	for i, br := range brs {
		ret[i] = toBuildTerminated(br)
	}
	return ret
}

func toAPILinks(lns []model.Link) []v1alpha1.UIResourceLink {
	ret := make([]v1alpha1.UIResourceLink, len(lns))
	for i, ln := range lns {
		ret[i] = v1alpha1.UIResourceLink{
			URL:  ln.URL,
			Name: ln.Name,
		}
	}
	return ret
}
