package controllers

import (
	"github.com/google/wire"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"

	"github.com/defn/dev/m/tilt/internal/controllers/core/cmd"
	"github.com/defn/dev/m/tilt/internal/controllers/core/configmap"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extension"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extensionrepo"
	"github.com/defn/dev/m/tilt/internal/controllers/core/filewatch"
	"github.com/defn/dev/m/tilt/internal/controllers/core/session"
	"github.com/defn/dev/m/tilt/internal/controllers/core/tiltfile"
	"github.com/defn/dev/m/tilt/internal/controllers/core/togglebutton"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uibutton"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uiresource"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uisession"
)

var controllerSet = wire.NewSet(
	filewatch.NewController,

	ProvideControllers,
)

func ProvideControllers(
	fileWatch *filewatch.Controller,
	cmds *cmd.Controller,
	uis *uisession.Reconciler,
	uir *uiresource.Reconciler,
	uib *uibutton.Reconciler,
	tfr *tiltfile.Reconciler,
	tbr *togglebutton.Reconciler,
	extr *extension.Reconciler,
	extrr *extensionrepo.Reconciler,
	cmr *configmap.Reconciler,
	sr *session.Reconciler,
) []Controller {
	return []Controller{
		fileWatch,
		cmds,
		uis,
		uir,
		uib,
		tfr,
		tbr,
		extr,
		extrr,
		cmr,
		sr,
	}
}

var WireSet = wire.NewSet(
	NewTiltServerControllerManager,

	NewControllerBuilder,
	ProvideUncachedObjects,

	ProvideDeferredClient,
	wire.Bind(new(ctrlclient.Client), new(*DeferredClient)),

	cmd.WireSet,
	controllerSet,
	uiresource.WireSet,
	uisession.WireSet,
	uibutton.WireSet,
	togglebutton.WireSet,
	tiltfile.WireSet,
	extensionrepo.WireSet,
	extension.WireSet,
	configmap.WireSet,
	session.WireSet,
)
