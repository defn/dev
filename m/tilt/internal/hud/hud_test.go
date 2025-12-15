package hud

import (
	"bytes"
	"testing"
	"time"

	"github.com/gdamore/tcell"

	"github.com/defn/dev/m/tilt/internal/openurl"
	"github.com/defn/dev/m/tilt/internal/rty"
	"github.com/defn/dev/m/tilt/internal/testutils"
)

func TestRenderInit(t *testing.T) {
	logs := new(bytes.Buffer)
	ctx := testutils.ForkedCtxForTest(logs)

	clockForTest := func() time.Time { return time.Date(2017, 1, 1, 12, 0, 0, 0, time.UTC) }
	r := NewRenderer(clockForTest)
	r.rty = rty.NewRTY(tcell.NewSimulationScreen(""), t)
	hud := NewHud(r, openurl.BrowserOpen)
	hud.(*Hud).refresh(ctx) // Ensure we render without error
}
