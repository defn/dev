package configmaps

import (
	"github.com/defn/dev/m/tilt/internal/store"
)

func HandleConfigMapUpsertAction(state *store.EngineState, action ConfigMapUpsertAction) {
	n := action.ConfigMap.Name
	state.ConfigMaps[n] = action.ConfigMap
}

func HandleConfigMapDeleteAction(state *store.EngineState, action ConfigMapDeleteAction) {
	delete(state.ConfigMaps, action.Name)
}
