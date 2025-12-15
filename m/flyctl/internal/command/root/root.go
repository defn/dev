// Package root implements the root command.
package root

import (
	"context"
	"log"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"

	"github.com/superfly/flyctl/flyctl"
	"github.com/superfly/flyctl/internal/buildinfo"
	"github.com/superfly/flyctl/internal/command"
	"github.com/superfly/flyctl/internal/command/agent"
	"github.com/superfly/flyctl/internal/command/auth"
	"github.com/superfly/flyctl/internal/command/config"
	"github.com/superfly/flyctl/internal/command/curl"
	"github.com/superfly/flyctl/internal/command/dig"
	"github.com/superfly/flyctl/internal/command/ping"
	"github.com/superfly/flyctl/internal/command/proxy"
	"github.com/superfly/flyctl/internal/command/tokens"
	"github.com/superfly/flyctl/internal/command/version"
	"github.com/superfly/flyctl/internal/command/wireguard"
	"github.com/superfly/flyctl/internal/flag/flagnames"
)

// New initializes and returns a reference to a new root command.
func New() *cobra.Command {
	const (
		long  = `This is flyctl, the Fly.io command line interface.`
		short = "The Fly.io command line interface"
	)

	exePath, err := os.Executable()
	var exe string
	if err != nil {
		log.Printf("WARN: failed to find executable, error=%q", err)
		exe = "fly"
	} else {
		exe = filepath.Base(exePath)
	}

	root := command.New(exe, short, long, run)
	root.Version = buildinfo.Version().String()
	root.PersistentPreRun = func(cmd *cobra.Command, args []string) {
		cmd.SilenceUsage = true
		cmd.SilenceErrors = true
	}

	fs := root.PersistentFlags()
	_ = fs.StringP(flagnames.AccessToken, "t", "", "Fly API Access Token")
	_ = fs.BoolP(flagnames.Verbose, "", false, "Verbose output")
	_ = fs.BoolP(flagnames.Debug, "", false, "Print additional logs and traces")

	flyctl.InitConfig()

	root.AddCommand(
		// Core commands
		version.New(),
		group(auth.New(), "acl"),
		group(tokens.New(), "acl"),
		group(config.New(), "configuring"),

		// WireGuard commands
		agent.New(),
		group(wireguard.New(), "upkeep"),

		// WireGuard-dependent utilities
		group(dig.New(), "upkeep"),
		group(ping.New(), "upkeep"),
		group(proxy.New(), "upkeep"),
		curl.New(),
	)

	root.AddGroup(&cobra.Group{
		ID:    "acl",
		Title: "Access control",
	})
	root.AddGroup(&cobra.Group{
		ID:    "configuring",
		Title: "Configuration",
	})
	root.AddGroup(&cobra.Group{
		ID:    "upkeep",
		Title: "WireGuard utilities",
	})

	return root
}

func run(ctx context.Context) error {
	cmd := command.FromContext(ctx)

	cmd.Println(cmd.Long)
	cmd.Println()
	cmd.Println("Usage:")
	cmd.Printf("  %s\n", cmd.UseLine())
	cmd.Printf("  %s [command]\n", cmd.Name())
	cmd.Println()
	cmd.Println("Use --help for more information about a command.")
	cmd.Println()
	cmd.Printf("Running %s v%s\n", buildinfo.Name(), buildinfo.Version())

	return nil
}

func group(cmd *cobra.Command, id string) *cobra.Command {
	cmd.GroupID = id
	return cmd
}
