package tiltfile

import (
	"time"

	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/defn/dev/m/tilt/pkg/model/logstore"
)

type ConfigsReloadStartedAction struct {
	Name         model.ManifestName
	FilesChanged []string
	StartTime    time.Time
	SpanID       logstore.SpanID
	Reason       model.BuildReason
}

func (ConfigsReloadStartedAction) Action() {}

type ConfigsReloadedAction struct {
	Name model.ManifestName

	// TODO(nick): Embed TiltfileLoadResult instead of copying fields.
	Manifests   []model.Manifest
	Tiltignore  model.Dockerignore
	ConfigFiles []string

	FinishTime time.Time
	Err        error
	Warnings   []string
	Features   map[string]bool
	TeamID     string
	Secrets    model.SecretSet
	VersionSettings model.VersionSettings
	UpdateSettings  model.UpdateSettings
	WatchSettings   model.WatchSettings

	// A checkpoint into the logstore when Tiltfile execution started.
	// Useful for knowing how far back in time we have to scrub secrets.
	CheckpointAtExecStart logstore.Checkpoint
}

func (ConfigsReloadedAction) Action() {}
