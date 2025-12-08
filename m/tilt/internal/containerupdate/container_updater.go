package containerupdate

import (
	"context"
	"io"

	"github.com/defn/dev/m/tilt/internal/store/liveupdates"
	"github.com/defn/dev/m/tilt/pkg/model"
)

type ContainerUpdater interface {
	UpdateContainer(ctx context.Context, cInfo liveupdates.Container,
		archiveToCopy io.Reader, filesToDelete []string, cmds []model.Cmd, hotReload bool) error
}
