package webview

import (
	"github.com/tilt-dev/wmclient/pkg/analytics"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/model"
)

func newState(manifests []model.Manifest) *store.EngineState {
	ret := store.NewState()
	ret.AnalyticsEnvOpt = analytics.OptDefault
	for _, m := range manifests {
		ret.ManifestTargets[m.Name] = store.NewManifestTarget(m)
		ret.ManifestDefinitionOrder = append(ret.ManifestDefinitionOrder, m.Name)
	}

	return ret
}
