// Package command implements helpers useful for when building cobra commands.
package command

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"time"

	"github.com/defn/dev/m/flyctl/internal/command/auth/webauth"
	"github.com/defn/dev/m/flyctl/internal/flyutil"
	"github.com/defn/dev/m/flyctl/internal/prompt"
	"github.com/defn/dev/m/flyctl/iostreams"
	"github.com/skratchdot/open-golang/open"
	"github.com/spf13/cobra"
	fly "github.com/superfly/fly-go"

	"github.com/defn/dev/m/flyctl/internal/buildinfo"
	"github.com/defn/dev/m/flyctl/internal/cache"
	"github.com/defn/dev/m/flyctl/internal/cmdutil/preparers"
	"github.com/defn/dev/m/flyctl/internal/config"
	"github.com/defn/dev/m/flyctl/internal/env"
	"github.com/defn/dev/m/flyctl/internal/flag"
	"github.com/defn/dev/m/flyctl/internal/logger"
	"github.com/defn/dev/m/flyctl/internal/state"
	"github.com/defn/dev/m/flyctl/internal/task"
	"github.com/defn/dev/m/flyctl/internal/update"
	"github.com/defn/dev/m/flyctl/internal/version"
)

type Runner func(context.Context) error

const (
	// TokenTimeout defines how long a login session is valid before requiring re-authentication
	TokenTimeout = 30 * 24 * time.Hour // 30 days
)

func New(usage, short, long string, fn Runner, p ...preparers.Preparer) *cobra.Command {
	return &cobra.Command{
		Use:   usage,
		Short: short,
		Long:  long,
		RunE:  newRunE(fn, p...),
	}
}

// Preparers are split between here and the preparers package because
// tab-completion needs to run *some* of them, and importing this package from there
// would create a circular dependency.
var commonPreparers = []preparers.Preparer{
	preparers.ApplyAliases,
	determineHostname,
	determineWorkingDir,
	preparers.DetermineConfigDir,
	ensureConfigDirExists,
	ensureConfigDirPerms,
	loadCache,
	preparers.LoadConfig,
	startQueryingForNewRelease,
	promptAndAutoUpdate,
}

var authPreparers = []preparers.Preparer{
	preparers.InitClient,
	killOldAgent,
}

func newRunE(fn Runner, preparers ...preparers.Preparer) func(*cobra.Command, []string) error {
	if fn == nil {
		return nil
	}

	return func(cmd *cobra.Command, _ []string) (err error) {
		ctx := cmd.Context()
		ctx = NewContext(ctx, cmd)
		ctx = flag.NewContext(ctx, cmd.Flags())

		// run the common preparers
		if ctx, err = prepare(ctx, commonPreparers...); err != nil {
			return
		}

		// run the preparers that perform or require authorization
		if ctx, err = prepare(ctx, authPreparers...); err != nil {
			return
		}

		// run the preparers specific to the command
		if ctx, err = prepare(ctx, preparers...); err != nil {
			return
		}

		// start task manager using the prepared context
		task.FromContext(ctx).Start(ctx)

		// run the command
		if err = fn(ctx); err == nil {
			// and finally, run the finalizer
			finalize(ctx)
		}

		return
	}
}

func prepare(parent context.Context, preparers ...preparers.Preparer) (ctx context.Context, err error) {
	ctx = parent

	for _, p := range preparers {
		if ctx, err = p(ctx); err != nil {
			break
		}
	}

	return
}

func finalize(ctx context.Context) {
	// flush the cache to disk if required
	if c := cache.FromContext(ctx); c.Dirty() {
		path := filepath.Join(state.ConfigDirectory(ctx), cache.FileName)

		if err := c.Save(path); err != nil {
			logger.FromContext(ctx).
				Warnf("failed saving cache to %s: %v", path, err)
		}
	}
}

func determineHostname(ctx context.Context) (context.Context, error) {
	h, err := os.Hostname()
	if err != nil {
		return nil, fmt.Errorf("failed determining hostname: %w", err)
	}

	logger.FromContext(ctx).
		Debugf("determined hostname: %q", h)

	return state.WithHostname(ctx, h), nil
}

func determineWorkingDir(ctx context.Context) (context.Context, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, fmt.Errorf("failed determining working directory: %w", err)
	}

	logger.FromContext(ctx).
		Debugf("determined working directory: %q", wd)

	return state.WithWorkingDirectory(ctx, wd), nil
}

func ensureConfigDirExists(ctx context.Context) (context.Context, error) {
	dir := state.ConfigDirectory(ctx)

	switch fi, err := os.Stat(dir); {
	case errors.Is(err, fs.ErrNotExist):
		if err := os.MkdirAll(dir, 0o700); err != nil {
			return nil, fmt.Errorf("failed creating config directory: %w", err)
		}
	case err != nil:
		return nil, fmt.Errorf("failed stat-ing config directory: %w", err)
	case !fi.IsDir():
		return nil, fmt.Errorf("the path to the config directory (%s) is occupied by not a directory", dir)
	}

	logger.FromContext(ctx).
		Debug("ensured config directory exists.")

	return ctx, nil
}

func ensureConfigDirPerms(parent context.Context) (ctx context.Context, err error) {
	defer func() {
		if err != nil {
			ctx = nil
			err = fmt.Errorf("failed ensuring config directory perms: %w", err)

			return
		}

		logger.FromContext(ctx).
			Debug("ensured config directory perms.")
	}()

	ctx = parent
	dir := state.ConfigDirectory(parent)

	var f *os.File
	if f, err = os.CreateTemp(dir, "perms.*"); err != nil {
		return
	}
	defer func() {
		if e := os.Remove(f.Name()); err == nil {
			err = e
		}
	}()

	err = f.Close()

	return
}

func loadCache(ctx context.Context) (context.Context, error) {
	logger := logger.FromContext(ctx)

	path := filepath.Join(state.ConfigDirectory(ctx), cache.FileName)

	c, err := cache.Load(path)
	if err != nil {
		c = cache.New()

		if !errors.Is(err, fs.ErrNotExist) {
			logger.Warnf("failed loading cache file from %s: %v", path, err)
		}
	}

	logger.Debug("cache loaded.")

	return cache.NewContext(ctx, c), nil
}

func startQueryingForNewRelease(ctx context.Context) (context.Context, error) {
	logger := logger.FromContext(ctx)

	cache := cache.FromContext(ctx)
	if !update.Check() || time.Since(cache.LastCheckedAt()) < time.Hour {
		logger.Debug("skipped querying for new release")

		return ctx, nil
	}

	channel := cache.Channel()

	queryRelease := func(parent context.Context) {
		logger.Debug("started querying for new release")

		ctx, cancel := context.WithTimeout(parent, time.Second)
		defer cancel()

		switch r, err := update.LatestRelease(ctx, channel); {
		case err == nil:
			if r == nil {
				break
			}

			// The API won't return yanked versions, but we don't have a good way
			// to yank homebrew releases. If we're under homebrew, we'll validate through the API
			if update.IsUnderHomebrew() {
				if relErr := update.ValidateRelease(ctx, r.Version); relErr != nil {
					logger.Debugf("latest release %s is invalid: %v", r.Version, relErr)
					break
				}
			}

			cache.SetLatestRelease(channel, r)

			// Check if the current version has been yanked.
			if cache.IsCurrentVersionInvalid() == "" {
				currentRelErr := update.ValidateRelease(ctx, buildinfo.Version().String())
				if currentRelErr != nil {
					var invalidRelErr *update.InvalidReleaseError
					if errors.As(currentRelErr, &invalidRelErr) {
						cache.SetCurrentVersionInvalid(invalidRelErr)
					}
				}
			}

			logger.Debugf("querying for release resulted to %v", r.Version)
		case errors.Is(err, context.Canceled), errors.Is(err, context.DeadlineExceeded):
			break
		default:
			logger.Warnf("failed querying for new release: %v", err)
		}
	}

	// If it's been more than a week since we've checked for a new release,
	// check synchronously. Otherwise, check asynchronously.
	if time.Since(cache.LastCheckedAt()) > (24 * time.Hour * 7) {
		queryRelease(ctx)
	} else {
		task.FromContext(ctx).Run(queryRelease)
	}

	return ctx, nil
}

// shouldIgnore allows a preparer to disable itself for specific commands
func shouldIgnore(ctx context.Context, cmds [][]string) bool {
	cmd := FromContext(ctx)

	for _, ignoredCmd := range cmds {
		match := true
		currentCmd := cmd
		for i := len(ignoredCmd) - 1; i >= 0; i-- {
			if !currentCmd.HasParent() || currentCmd.Use != ignoredCmd[i] {
				match = false
				break
			}
			currentCmd = currentCmd.Parent()
		}
		if match {
			if !currentCmd.HasParent() {
				return true
			}
		}
	}
	return false
}

func promptAndAutoUpdate(ctx context.Context) (context.Context, error) {
	cfg := config.FromContext(ctx)
	if shouldIgnore(ctx, [][]string{
		{"version"},
		{"version", "upgrade"},
	}) {
		return ctx, nil
	}

	logger.FromContext(ctx).Debug("checking for updates...")

	if !update.Check() {
		return ctx, nil
	}

	var (
		current   = buildinfo.Version()
		cache     = cache.FromContext(ctx)
		logger    = logger.FromContext(ctx)
		io        = iostreams.FromContext(ctx)
		colorize  = io.ColorScheme()
		latestRel = cache.LatestRelease()
		silent    = cfg.JSONOutput
	)

	if latestRel == nil {
		return ctx, nil
	}

	versionInvalidMsg := cache.IsCurrentVersionInvalid()
	if versionInvalidMsg != "" && !silent {
		fmt.Fprintf(io.ErrOut, "The current version of flyctl is invalid: %s\n", versionInvalidMsg)
	}

	latest, err := version.Parse(latestRel.Version)
	if err != nil {
		logger.Warnf("error parsing version number '%s': %s", latestRel.Version, err)
		return ctx, err
	}

	if !latest.Newer(current) {
		if versionInvalidMsg != "" && !silent {
			fmt.Fprintln(io.ErrOut, "but there is not a newer version available. Proceed with caution!")
		}
		return ctx, nil
	}

	promptForUpdate := false

	if cfg.AutoUpdate && !env.IsCI() && update.CanUpdateThisInstallation() {
		if versionInvalidMsg != "" || current.SignificantlyBehind(latest) {
			if !silent {
				fmt.Fprintln(io.ErrOut, colorize.Green(fmt.Sprintf("Automatically updating %s -> %s.", current, latestRel.Version)))
			}

			err := update.UpgradeInPlace(ctx, io, latestRel.Prerelease, silent)
			if err != nil {
				return nil, fmt.Errorf("failed to update, and the current version is severely out of date: %w", err)
			}
			err = update.Relaunch(ctx, silent)
			return nil, fmt.Errorf("failed to relaunch after updating: %w", err)
		} else if runtime.GOOS != "windows" {
			if err := update.BackgroundUpdate(); err != nil {
				fmt.Fprintf(io.ErrOut, "failed to autoupdate: %s\n", err)
			} else {
				promptForUpdate = false
			}
		}
	}
	if !silent {
		if !cfg.AutoUpdate && versionInvalidMsg != "" {
			fmt.Fprintln(io.ErrOut, "Proceed with caution!")
		}
		if promptForUpdate {
			fmt.Fprintln(io.ErrOut, colorize.Yellow(fmt.Sprintf("Update available %s -> %s.", current, latestRel.Version)))
			fmt.Fprintln(io.ErrOut, colorize.Yellow(fmt.Sprintf("Run \"%s\" to upgrade.", colorize.Bold(buildinfo.Name()+" version upgrade"))))
		}
	}

	return ctx, nil
}

func killOldAgent(ctx context.Context) (context.Context, error) {
	path := filepath.Join(state.ConfigDirectory(ctx), "agent.pid")

	data, err := os.ReadFile(path)
	if errors.Is(err, fs.ErrNotExist) {
		return ctx, nil
	} else if err != nil {
		return nil, fmt.Errorf("failed reading old agent's PID file: %w", err)
	}

	pid, err := strconv.Atoi(string(data))
	if err != nil {
		return nil, fmt.Errorf("failed determining old agent's PID: %w", err)
	}

	logger := logger.FromContext(ctx)
	unlink := func() (err error) {
		if err = os.Remove(path); err != nil {
			err = fmt.Errorf("failed removing old agent's PID file: %w", err)

			return
		}

		logger.Debug("removed old agent's PID file.")

		return
	}

	p, err := os.FindProcess(pid)
	if err != nil {
		return nil, fmt.Errorf("failed retrieving old agent's process: %w", err)
	} else if p == nil {
		return ctx, unlink()
	}

	if err := p.Kill(); err != nil && !errors.Is(err, os.ErrProcessDone) {
		return nil, fmt.Errorf("failed killing old agent process: %w", err)
	}

	logger.Debugf("killed old agent (PID: %d)", pid)

	if err := unlink(); err != nil {
		return nil, err
	}

	time.Sleep(time.Second)

	return ctx, nil
}

// RequireSession is a Preparer which makes sure a session exists.
func RequireSession(ctx context.Context) (context.Context, error) {
	client := flyutil.ClientFromContext(ctx)
	cfg := config.FromContext(ctx)

	if !client.Authenticated() {
		return handleReLogin(ctx, "not_authenticated")
	}

	tokenFromEnv := env.First(config.AccessTokenEnvKey, config.APITokenEnvKey) != ""

	if !tokenFromEnv {
		if cfg.LastLogin.IsZero() {
			logger.FromContext(ctx).Debug("no login timestamp found, prompting for re-login")
			return handleReLogin(ctx, "no_timestamp")
		}

		if time.Since(cfg.LastLogin) > TokenTimeout {
			logger.FromContext(ctx).Debugf("token expired (%v since login, timeout is %v)", time.Since(cfg.LastLogin), TokenTimeout)
			return handleReLogin(ctx, "expired")
		}
	}

	config.MonitorTokens(ctx, config.Tokens(ctx), tryOpenUserURL)

	return ctx, nil
}

func handleReLogin(ctx context.Context, reason string) (context.Context, error) {
	io := iostreams.FromContext(ctx)

	if io.IsInteractive() &&
		!env.IsCI() &&
		!flag.GetBool(ctx, "now") &&
		!flag.GetBool(ctx, "json") &&
		!flag.GetBool(ctx, "quiet") &&
		!flag.GetBool(ctx, "yes") {

		colorize := io.ColorScheme()

		if reason == "no_timestamp" || reason == "expired" {
			fmt.Fprintf(io.Out, "%s\n", colorize.Purple("Welcome back!"))
			fmt.Fprintf(io.Out, "Your session has expired, please log in to continue using flyctl.\n\n")
		}

		var promptMessage string
		if reason == "not_authenticated" {
			promptMessage = "You must be logged in to do this. Would you like to sign in?"
		} else {
			promptMessage = "Would you like to sign in?"
		}

		confirmed, err := prompt.Confirm(ctx, promptMessage)
		if err != nil {
			return nil, err
		}
		if !confirmed {
			return nil, fly.ErrNoAuthToken
		}

		token, err := webauth.RunWebLogin(ctx, false)
		if err != nil {
			return nil, err
		}
		if err := webauth.SaveToken(ctx, token); err != nil {
			return nil, err
		}

		logger.FromContext(ctx).Debug("reloading config after login")
		if ctx, err = prepare(ctx, preparers.LoadConfig); err != nil {
			return nil, err
		}

		ctx = flyutil.NewContextWithClient(ctx, nil)

		logger.FromContext(ctx).Debug("re-running auth preparers after login")
		if ctx, err = prepare(ctx, authPreparers...); err != nil {
			return nil, err
		}

		return ctx, nil
	} else {
		return nil, fly.ErrNoAuthToken
	}
}

func tryOpenUserURL(ctx context.Context, url string) error {
	io := iostreams.FromContext(ctx)

	if !io.IsInteractive() || env.IsCI() {
		return errors.New("failed opening browser")
	}

	if err := open.Run(url); err != nil {
		fmt.Fprintf(io.ErrOut, "failed opening browser. Copy the url (%s) into a browser and continue\n", url)
	}

	return nil
}

func ChangeWorkingDirectoryToFirstArgIfPresent(ctx context.Context) (context.Context, error) {
	wd := flag.FirstArg(ctx)
	if wd == "" {
		return ctx, nil
	}
	return ChangeWorkingDirectory(ctx, wd)
}

func ChangeWorkingDirectory(ctx context.Context, wd string) (context.Context, error) {
	if !filepath.IsAbs(wd) {
		p, err := filepath.Abs(wd)
		if err != nil {
			return nil, fmt.Errorf("failed converting %s to an absolute path: %w", wd, err)
		}
		wd = p
	}

	if err := os.Chdir(wd); err != nil {
		return nil, fmt.Errorf("failed changing working directory: %w", err)
	}

	return state.WithWorkingDirectory(ctx, wd), nil
}
