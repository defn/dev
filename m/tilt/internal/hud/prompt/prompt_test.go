package prompt

import (
	"bytes"
	"context"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/testutils"
	"github.com/defn/dev/m/tilt/internal/testutils/bufsync"
)

func TestOpenStream(t *testing.T) {
	f := newFixture(t)

	_ = f.prompt.OnChange(f.ctx, f.st, store.LegacyChangeSummary())

	assert.Contains(t, f.out.String(), "(s) to stream logs")

	f.input.nextRune <- 's'

	action := f.st.WaitForAction(t, reflect.TypeOf(SwitchTerminalModeAction{}))
	assert.Equal(t, SwitchTerminalModeAction{Mode: store.TerminalModeStream}, action)
}

func TestOpenHUD(t *testing.T) {
	f := newFixture(t)

	_ = f.prompt.OnChange(f.ctx, f.st, store.LegacyChangeSummary())

	assert.Contains(t, f.out.String(), "(t) to open legacy terminal mode")

	f.input.nextRune <- 't'

	action := f.st.WaitForAction(t, reflect.TypeOf(SwitchTerminalModeAction{}))
	assert.Equal(t, SwitchTerminalModeAction{Mode: store.TerminalModeHUD}, action)
}

func TestInitOutput(t *testing.T) {
	f := newFixture(t)

	f.prompt.SetInitOutput(bytes.NewBuffer([]byte("this is a warning\n")))
	_ = f.prompt.OnChange(f.ctx, f.st, store.LegacyChangeSummary())

	assert.Contains(t, f.out.String(), "this is a warning")
}

type fixture struct {
	ctx    context.Context
	cancel func()
	out    *bufsync.ThreadSafeBuffer
	st     *store.TestingStore
	input  *fakeInput
	prompt *TerminalPrompt
}

func newFixture(t *testing.T) *fixture {
	ctx := testutils.LoggerCtx()
	ctx, cancel := context.WithCancel(ctx)
	out := bufsync.NewThreadSafeBuffer()
	st := store.NewTestingStore()
	st.WithState(func(state *store.EngineState) {
		state.TerminalMode = store.TerminalModePrompt
	})
	i := &fakeInput{ctx: ctx, nextRune: make(chan rune)}
	openInput := OpenInput(func() (TerminalInput, error) { return i, nil })

	prompt := NewTerminalPrompt(openInput, out)
	ret := &fixture{
		ctx:    ctx,
		cancel: cancel,
		out:    out,
		st:     st,
		input:  i,
		prompt: prompt,
	}

	t.Cleanup(ret.TearDown)

	return ret
}

func (f *fixture) TearDown() {
	f.cancel()
}

type fakeInput struct {
	ctx      context.Context
	nextRune chan rune
}

func (i *fakeInput) Close() error { return nil }

func (i *fakeInput) ReadNextRune() (rune, error) {
	select {
	case r := <-i.nextRune:
		return r, nil
	case <-i.ctx.Done():
		return 0, i.ctx.Err()
	}
}
