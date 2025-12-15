package preparers

import (
	"context"
	"fmt"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/defn/dev/m/flyctl/helpers"
	"github.com/defn/dev/m/flyctl/internal/config"
	"github.com/defn/dev/m/flyctl/internal/flag/flagctx"
	"github.com/defn/dev/m/flyctl/internal/flyutil"
	"github.com/defn/dev/m/flyctl/internal/instrument"
	"github.com/defn/dev/m/flyctl/internal/logger"
	"github.com/defn/dev/m/flyctl/internal/state"
	"github.com/spf13/pflag"
	fly "github.com/superfly/fly-go"
	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
)

type Preparer func(context.Context) (context.Context, error)

func LoadConfig(ctx context.Context) (context.Context, error) {
	logger := logger.FromContext(ctx)

	cfg, err := config.Load(ctx, filepath.Join(state.ConfigDirectory(ctx), config.FileName))
	if err != nil {
		return nil, err
	}

	logger.Debug("config initialized.")

	return config.NewContext(ctx, cfg), nil
}

func InitClient(ctx context.Context) (context.Context, error) {
	logger := logger.FromContext(ctx)
	cfg := config.FromContext(ctx)

	fly.SetBaseURL(cfg.APIBaseURL)
	fly.SetErrorLog(cfg.LogGQLErrors)
	fly.SetInstrumenter(instrument.ApiAdapter)
	fly.SetTransport(otelhttp.NewTransport(http.DefaultTransport))

	if flyutil.ClientFromContext(ctx) == nil {
		client := flyutil.NewClientFromOptions(ctx, fly.ClientOptions{Tokens: cfg.Tokens})
		logger.Debug("client initialized.")
		ctx = flyutil.NewContextWithClient(ctx, client)
	}

	return ctx, nil
}

func DetermineConfigDir(ctx context.Context) (context.Context, error) {
	dir, err := helpers.GetConfigDirectory()
	if err != nil {
		return ctx, err
	}

	logger.FromContext(ctx).
		Debugf("determined config directory: %q", dir)

	return state.WithConfigDirectory(ctx, dir), nil
}

// ApplyAliases consolidates flags with aliases into a single source-of-truth flag.
func ApplyAliases(ctx context.Context) (context.Context, error) {
	var (
		invalidFlagNames []string
		invalidTypes     []string

		flags = flagctx.FromContext(ctx)
	)
	flags.VisitAll(func(f *pflag.Flag) {
		aliases, ok := f.Annotations["flyctl_alias"]
		if !ok {
			return
		}

		name := f.Name
		gotValue := false
		origFlag := flags.Lookup(name)

		if origFlag == nil {
			invalidFlagNames = append(invalidFlagNames, name)
		} else {
			gotValue = origFlag.Changed
		}

		for _, alias := range aliases {
			aliasFlag := flags.Lookup(alias)
			if aliasFlag == nil {
				invalidFlagNames = append(invalidFlagNames, alias)
				continue
			}
			if origFlag == nil {
				continue
			}
			if aliasFlag.Value.Type() != origFlag.Value.Type() {
				invalidTypes = append(invalidTypes, fmt.Sprintf("%s (%s) and %s (%s)", name, origFlag.Value.Type(), alias, aliasFlag.Value.Type()))
			}
			if !gotValue && aliasFlag.Changed {
				err := origFlag.Value.Set(aliasFlag.Value.String())
				if err != nil {
					panic(err)
				}
				origFlag.Changed = true
			}
		}
	})

	var err error
	{
		var errorMessages []string
		if len(invalidFlagNames) > 0 {
			errorMessages = append(errorMessages, fmt.Sprintf("flags '%v' are not valid flags", invalidFlagNames))
		}
		if len(invalidTypes) > 0 {
			errorMessages = append(errorMessages, fmt.Sprintf("flags '%v' have different types", invalidTypes))
		}
		if len(errorMessages) > 1 {
			err = fmt.Errorf("multiple errors occurred:\n > %s\n", strings.Join(errorMessages, "\n > "))
		} else if len(errorMessages) == 1 {
			err = fmt.Errorf("%s", errorMessages[0])
		}
	}
	return ctx, err
}
