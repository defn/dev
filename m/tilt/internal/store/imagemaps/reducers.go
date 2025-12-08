package imagemaps

import (
	"github.com/defn/dev/m/tilt/internal/store"
)

func HandleImageMapUpsertAction(state *store.EngineState, action ImageMapUpsertAction) {
	n := action.ImageMap.Name
	state.ImageMaps[n] = action.ImageMap
}

func HandleImageMapDeleteAction(state *store.EngineState, action ImageMapDeleteAction) {
	delete(state.ImageMaps, action.Name)
}
