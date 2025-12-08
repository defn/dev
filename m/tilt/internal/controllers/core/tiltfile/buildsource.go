package tiltfile

import (
	"context"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/model"
	"github.com/defn/dev/m/tilt/pkg/model/logstore"
)

// BuildEntry is vestigial, but currently used to help manage state about a tiltfile build.
type BuildEntry struct {
	Name                  model.ManifestName
	FilesChanged          []string
	BuildReason           model.BuildReason
	Args                  []string
	TiltfilePath          string
	CheckpointAtExecStart logstore.Checkpoint
	LoadCount             int
	ArgsChanged           bool
}

func (be *BuildEntry) WithLogger(ctx context.Context, st store.RStore) context.Context {
	return store.WithManifestLogHandler(ctx, st, be.Name, SpanIDForLoadCount(be.Name, be.LoadCount))
}
