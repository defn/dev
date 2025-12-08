package hud

import (
	"bytes"
	"net/url"
	"testing"
	"time"

	"github.com/gdamore/tcell"

	"github.com/defn/dev/m/tilt/internal/openurl"
	"github.com/defn/dev/m/tilt/internal/rty"
	"github.com/defn/dev/m/tilt/internal/testutils"
	"github.com/defn/dev/m/tilt/pkg/model"
)

func TestRenderInit(t *testing.T) {
	logs := new(bytes.Buffer)
	ctx, _, ta := testutils.ForkedCtxAndAnalyticsForTest(logs)

	clockForTest := func() time.Time { return time.Date(2017, 1, 1, 12, 0, 0, 0, time.UTC) }
	r := NewRenderer(clockForTest)
	r.rty = rty.NewRTY(tcell.NewSimulationScreen(""), t)
	webURL, _ := url.Parse("http://localhost:10350")
	hud := NewHud(r, model.WebURL(*webURL), ta, openurl.BrowserOpen)
	hud.(*Hud).refresh(ctx) // Ensure we render without error
}
