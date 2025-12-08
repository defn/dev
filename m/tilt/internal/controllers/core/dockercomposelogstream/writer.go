package dockercomposelogstream

import (
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/store/dockercomposeservices"
	"github.com/defn/dev/m/tilt/pkg/logger"
	"github.com/defn/dev/m/tilt/pkg/model"
)

type LogActionWriter struct {
	store        store.RStore
	manifestName model.ManifestName
}

func (w *LogActionWriter) Write(p []byte) (n int, err error) {
	w.store.Dispatch(store.NewLogAction(w.manifestName,
		dockercomposeservices.SpanIDForDCService(w.manifestName), logger.InfoLvl, nil, p))
	return len(p), nil
}
