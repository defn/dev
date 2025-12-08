package engine

import (
	"github.com/defn/dev/m/tilt/internal/controllers"
	"github.com/defn/dev/m/tilt/internal/engine/configs"
	"github.com/defn/dev/m/tilt/internal/engine/local"
	"github.com/defn/dev/m/tilt/internal/engine/session"
	"github.com/defn/dev/m/tilt/internal/engine/uiresource"
	"github.com/defn/dev/m/tilt/internal/engine/uisession"
	"github.com/defn/dev/m/tilt/internal/hud"
	"github.com/defn/dev/m/tilt/internal/hud/prompt"
	"github.com/defn/dev/m/tilt/internal/store"
)

func ProvideSubscribers(
	tscm *controllers.TiltServerControllerManager,
	cb *controllers.ControllerBuilder,
	hud hud.HeadsUpDisplay,
	ts *hud.TerminalStream,
	tp *prompt.TerminalPrompt,
	cc *configs.ConfigsController,
	tqs *configs.TriggerQueueSubscriber,
	lsc *local.ServerController,
	sc *session.Controller,
	uss *uisession.Subscriber,
	urs *uiresource.Subscriber,
) []store.Subscriber {
	return []store.Subscriber{
		// The controller manager must go first,
		// so that it can connect to it and make resources available.
		tscm,
		cb,
		ts,
		hud,
		tp,
		cc,
		tqs,
		lsc,
		sc,
		uss,
		urs,
	}
}
