package engine

import (
	"time"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/token"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/tilt-dev/wmclient/pkg/analytics"
)

func NewErrorAction(err error) store.ErrorAction {
	return store.NewErrorAction(err)
}

type InitAction struct {
	TiltfilePath string
	UserArgs     []string

	TiltBuild model.TiltBuild
	StartTime time.Time

	AnalyticsUserOpt analytics.Opt

	CloudAddress string
	Token        token.Token
	TerminalMode store.TerminalMode
}

func (InitAction) Action() {}

type ManifestReloadedAction struct {
	OldManifest model.Manifest
	NewManifest model.Manifest
	Error       error
}

func (ManifestReloadedAction) Action() {}

type HudStoppedAction struct {
	err error
}

func (HudStoppedAction) Action() {}

func NewHudStoppedAction(err error) HudStoppedAction {
	return HudStoppedAction{err}
}
