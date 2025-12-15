package ctrlc

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"syscall"
)

type Handle struct{ *boundSignal }
type boundSignal struct {
	sig  chan os.Signal
	once sync.Once
}

// Signals returns signals that correspond to Ctrl+C.
func Signals() []os.Signal {
	return []os.Signal{os.Interrupt, syscall.SIGTERM}
}

// ClearHandlers removes all Ctrl+C signal handlers. Use with care.
func ClearHandlers() {
	signal.Reset(Signals()...)
}

// Hook registers a function to be called when the user presses Ctrl+C.
// It returns a Handle, which must have its Done() method called to clean up.
// The event function will never be called more than once.
func Hook(event func()) Handle {
	signalCh := make(chan os.Signal, 1)
	signal.Notify(signalCh, Signals()...)
	go func() {
		sig := <-signalCh
		if sig == nil {
			return
		}
		// most terminals print ^C, this makes things easier to read.
		fmt.Fprintf(os.Stderr, "\n")
		event()
	}()
	return Handle{&boundSignal{sig: signalCh}}
}

// Done cleans up signal handlers.
func (h Handle) Done() {
	h.once.Do(func() {
		signal.Stop(h.sig)
		close(h.sig)
	})
}
