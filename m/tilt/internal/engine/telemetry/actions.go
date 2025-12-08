package telemetry

import (
	"github.com/defn/dev/m/tilt/pkg/model"
)

type TelemetryScriptRanAction struct {
	Status model.TelemetryStatus
}

func (TelemetryScriptRanAction) Action() {}
