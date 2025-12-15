package main

import (
	"context"
	"os"
	"os/signal"
	"runtime/pprof"
	"syscall"

	"golang.org/x/sys/unix"

	"github.com/defn/dev/m/flyctl/internal/buildinfo"
	"github.com/defn/dev/m/flyctl/internal/cli"
	"github.com/defn/dev/m/flyctl/iostreams"
)

// handleDebugSignal handles SIGUSR2 and dumps debug information.
func handleDebugSignal(ctx context.Context) {
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, unix.SIGUSR2)

	for {
		select {
		case <-sigCh:
			pprof.Lookup("goroutine").WriteTo(os.Stderr, 1)
		case <-ctx.Done():
			return
		}
	}
}

func main() {
	os.Exit(run())
}

func run() (exitCode int) {
	ctx, cancel := newContext()
	defer cancel()

	go handleDebugSignal(ctx)

	if !buildinfo.IsDev() {
		defer func() {
			if r := recover(); r != nil {
				exitCode = 3
			}
		}()
	}

	exitCode = cli.Run(ctx, iostreams.System(), os.Args[1:]...)

	return
}

func newContext() (context.Context, context.CancelFunc) {
	return signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
}
