package tiltfile

import (
	"fmt"

	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/defn/dev/m/tilt/pkg/model/logstore"
)

func SpanIDForLoadCount(mn model.ManifestName, loadCount int) logstore.SpanID {
	return logstore.SpanID(fmt.Sprintf("tiltfile:%s:%d", mn, loadCount))
}
