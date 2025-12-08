package tiltfile

import (
	"github.com/google/wire"

	"github.com/defn/dev/m/tilt/internal/tiltfile/cisettings"
	"github.com/defn/dev/m/tilt/internal/tiltfile/config"
	"github.com/defn/dev/m/tilt/internal/tiltfile/tiltextension"
	"github.com/defn/dev/m/tilt/internal/tiltfile/version"
)

var WireSet = wire.NewSet(
	ProvideTiltfileLoader,
	version.NewPlugin,
	config.NewPlugin,
	tiltextension.NewPlugin,
	cisettings.NewPlugin,
)
