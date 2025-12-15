// Package version implements the version command.
package version

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/spf13/cobra"

	"github.com/defn/dev/m/flyctl/internal/buildinfo"
	"github.com/defn/dev/m/flyctl/internal/command"
	"github.com/defn/dev/m/flyctl/internal/config"
	"github.com/defn/dev/m/flyctl/internal/flag"
	"github.com/defn/dev/m/flyctl/iostreams"
)

// New initializes and returns a new version Command.
func New() *cobra.Command {
	const (
		short = "Show version information for the flyctl command"
		long  = `Shows version information for the flyctl command itself, including version number and build date.`
	)

	version := command.New("version", short, long, run)
	flag.Add(version, flag.JSONOutput())
	return version
}

func run(ctx context.Context) (err error) {
	var (
		cfg  = config.FromContext(ctx)
		info = buildinfo.Info()
		out  = iostreams.FromContext(ctx).Out
	)

	if cfg.JSONOutput {
		err = json.NewEncoder(out).Encode(info)
	} else {
		_, err = fmt.Fprintln(out, info)
	}

	return
}
