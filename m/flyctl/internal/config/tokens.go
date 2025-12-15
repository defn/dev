package config

import (
	"context"
	"strings"
	"sync"
	"time"

	"github.com/superfly/fly-go/tokens"
	"github.com/defn/dev/m/flyctl/internal/logger"
	"github.com/defn/dev/m/flyctl/internal/task"
)

// UserURLCallback is a function that opens a URL in the user's browser. This is
// used for token discharge flows that require user interaction.
type UserURLCallback func(ctx context.Context, url string) error

// MonitorTokens does some housekeeping on the provided tokens. Then, in a
// goroutine, it continues to keep the tokens updated and fresh. The call to
// MonitorTokens will return as soon as the tokens are ready for use and the
// background job will run until the context is cancelled. Token updates include
//   - Keeping the tokens synced with the config file.
//   - Refreshing any expired discharge tokens.
//   - Pruning expired or invalid token.
func MonitorTokens(monitorCtx context.Context, t *tokens.Tokens, uucb UserURLCallback) {
	log := logger.FromContext(monitorCtx)
	file := t.FromFile()

	updated, err := refreshDischargeTokens(monitorCtx, t, uucb, 30*time.Second)
	if err != nil {
		log.Debugf("failed to update discharge tokens: %s", err)
	}

	if file != "" && updated {
		if err := SetAccessToken(file, t.All()); err != nil {
			log.Debugf("failed to persist updated tokens: %s", err)
		}
	}

	task.FromContext(monitorCtx).Run(func(taskCtx context.Context) {
		taskCtx, cancelTask := context.WithCancel(taskCtx)

		var m sync.Mutex
		var wg sync.WaitGroup

		wg.Add(2)

		if file != "" {
			log.Debugf("monitoring tokens at %s", file)
		} else {
			log.Debug("monitoring tokens in memory")
		}

		go monitorConfigTokenChanges(taskCtx, &m, t, wg.Done)
		go keepConfigTokensFresh(taskCtx, &m, t, uucb, wg.Done)

		// shut down when the task manager is shutting down or when the
		// ctx passed into MonitorTokens is cancelled.
		select {
		case <-taskCtx.Done():
		case <-monitorCtx.Done():
		}

		log.Debug("done monitoring tokens")
		cancelTask()
		wg.Wait()
	})
}

// monitorConfigTokenChanges watches for token changes in the config file. This can
// happen if a foreground process updates the config file while the agent is
// running.
func monitorConfigTokenChanges(ctx context.Context, m *sync.Mutex, t *tokens.Tokens, done func()) error {
	defer done()

	file := t.FromFile()
	if file == "" {
		return nil
	}

	ticker := time.NewTicker(15 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
			currentStr, err := ReadAccessToken(file)
			if err != nil {
				return err
			}

			current := tokens.ParseFromFile(currentStr, file)

			m.Lock()
			t.Replace(current)
			m.Unlock()
		}
	}
}

// keepConfigTokensFresh periodically updates our tokens and syncs those to the config
// file.
func keepConfigTokensFresh(ctx context.Context, m *sync.Mutex, t *tokens.Tokens, uucb UserURLCallback, done func()) error {
	defer done()

	ticker := time.NewTicker(time.Minute)
	defer ticker.Stop()

	logger := logger.FromContext(ctx)
	file := t.FromFile()

	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
			localCopy := t.Copy()
			beforeUpdate := t.Copy()

			updated, err := refreshDischargeTokens(ctx, localCopy, uucb, 2*time.Minute)
			if err != nil {
				logger.Debugf("failed to update discharge tokens: %s", err)
				// don't continue. might have been partial success
			}

			if !updated {
				continue
			}

			m.Lock()
			// don't clobber config file if it changed out from under us.
			if beforeUpdate.Equal(t) {
				t.Replace(localCopy)

				if file != "" {
					if err := SetAccessToken(file, t.All()); err != nil {
						logger.Debugf("failed to persist updated tokens: %s", err)

						// don't try again if we fail to write once
						file = ""
					}
				}
			}
			m.Unlock()
		}
	}
}

// refreshDischargeTokens attempts to refresh any expired discharge tokens. It
// returns true if any tokens were updated, which might be the case even if
// there was an error for other tokens.
//
// Some discharges may require user interaction in the form of opening a URL in
// the user's browser. Set the UserURLCallback package variable if you want to
// support this.
//
// Don't call this when other goroutines might also be accessing it.
func refreshDischargeTokens(ctx context.Context, t *tokens.Tokens, uucb UserURLCallback, advancePrune time.Duration) (bool, error) {
	updateOpts := []tokens.UpdateOption{
		tokens.WithDebugger(logger.FromContext(ctx)),
		tokens.WithAdvancePrune(advancePrune),
	}

	if uucb != nil {
		// Update without UserURLCallback to fetch tokens in parallel.
		updated, err := t.Update(ctx, updateOpts...)
		if err == nil || !strings.Contains(err.Error(), "missing user-url callback") {
			return updated, err
		}

		// Retry with UserURLCallback if we received a 'missing user-url callback' error.
		updateOpts = append(updateOpts, tokens.WithUserURLCallback(uucb))
	}

	return t.Update(ctx, updateOpts...)
}
