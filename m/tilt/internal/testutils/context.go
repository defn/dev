package testutils

import (
	"context"
	"fmt"
	"io"
	"os"
	"testing"

	"github.com/defn/dev/m/tilt/pkg/logger"
)

func LoggerCtx() context.Context {
	return logger.WithLogger(context.Background(), logger.NewTestLogger(os.Stdout))
}

// ForkedCtxForTest returns a context.Context suitable for use in tests (i.e. with
// logger attached), and with all output being copied to `w`
func ForkedCtxForTest(w io.Writer) context.Context {
	ctx := LoggerCtx()
	ctx = logger.CtxWithForkedOutput(ctx, w)
	return ctx
}

func FailOnNonCanceledErr(t testing.TB, err error, message string) {
	if err != nil && err != context.Canceled {
		fmt.Printf("%s: %v\n", message, err)
		t.Error(err)
	}
}
