package hud

import (
	"os"
	"sort"
	"sync"

	"github.com/defn/dev/m/tilt/internal/hud/view"
	"github.com/defn/dev/m/tilt/internal/ospath"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/defn/dev/m/tilt/pkg/model/logstore"
)

func StateToTerminalView(s store.EngineState, mu *sync.RWMutex) view.View {
	ret := view.View{}

	for _, ms := range s.TiltfileStates {
		ret.Resources = append(ret.Resources, tiltfileResourceView(ms))
	}

	for _, name := range s.ManifestDefinitionOrder {
		mt, ok := s.ManifestTargets[name]
		if !ok {
			continue
		}

		ms := mt.State
		if ms.DisableState == v1alpha1.DisableStateDisabled {
			// Don't show disabled resources in the terminal UI.
			continue
		}

		var absWatchDirs []string
		for i, p := range mt.Manifest.LocalPaths() {
			if i > 50 {
				// Bail out after 50 to avoid pathological performance issues.
				break
			}
			fi, err := os.Stat(p)

			// Treat this as a directory when there's an error.
			if err != nil || fi.IsDir() {
				absWatchDirs = append(absWatchDirs, p)
			}
		}

		var pendingBuildEdits []string
		for _, status := range ms.BuildStatuses {
			pendingBuildEdits = append(pendingBuildEdits, status.PendingFileChangesList()...)
		}

		pendingBuildEdits = ospath.FileListDisplayNames(absWatchDirs, pendingBuildEdits)

		buildHistory := append([]model.BuildRecord{}, ms.BuildHistory...)
		for i, build := range buildHistory {
			build.Edits = ospath.FileListDisplayNames(absWatchDirs, build.Edits)
			buildHistory[i] = build
		}

		currentBuild := ms.EarliestCurrentBuild()
		currentBuild.Edits = ospath.FileListDisplayNames(absWatchDirs, currentBuild.Edits)

		// Sort the strings to make the outputs deterministic.
		sort.Strings(pendingBuildEdits)

		endpoints := store.ManifestTargetEndpoints(mt)

		// NOTE(nick): Right now, the UX is designed to show the output exactly one
		// pod. A better UI might summarize the pods in other ways (e.g., show the
		// "most interesting" pod that's crash looping, or show logs from all pods
		// at once).
		_, pendingBuildSince := ms.HasPendingChanges()
		r := view.Resource{
			Name:               name,
			LastDeployTime:     ms.LastSuccessfulDeployTime,
			TriggerMode:        mt.Manifest.TriggerMode,
			BuildHistory:       buildHistory,
			PendingBuildEdits:  pendingBuildEdits,
			PendingBuildSince:  pendingBuildSince,
			PendingBuildReason: mt.NextBuildReason(),
			CurrentBuild:       currentBuild,
			Endpoints:          model.LinksToURLStrings(endpoints), // hud can't handle link names, just send URLs
			ResourceInfo:       resourceInfoView(mt),
		}

		ret.Resources = append(ret.Resources, r)
	}

	ret.LogReader = logstore.NewReader(mu, s.LogStore)
	ret.FatalError = s.FatalError

	return ret
}

const MainTiltfileManifestName = model.MainTiltfileManifestName

func tiltfileResourceView(ms *store.ManifestState) view.Resource {
	currentBuild := ms.EarliestCurrentBuild()
	tr := view.Resource{
		Name:         MainTiltfileManifestName,
		IsTiltfile:   true,
		CurrentBuild: currentBuild,
		BuildHistory: ms.BuildHistory,
		ResourceInfo: view.TiltfileResourceInfo{},
	}
	if !currentBuild.Empty() {
		tr.PendingBuildSince = currentBuild.StartTime
	} else {
		tr.LastDeployTime = ms.LastBuild().FinishTime
	}
	return tr
}

func resourceInfoView(mt *store.ManifestTarget) view.ResourceInfoView {
	runStatus := mt.RuntimeStatus()
	switch state := mt.State.RuntimeState.(type) {
	case store.LocalRuntimeState:
		return view.NewLocalResourceInfo(runStatus, state.PID, state.SpanID)
	default:
		// Return empty local resource info for unknown types
		return view.LocalResourceInfo{}
	}
}
