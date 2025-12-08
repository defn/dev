package controllers

import (
	"github.com/google/wire"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"

	"github.com/defn/dev/m/tilt/internal/controllers/core/cluster"
	"github.com/defn/dev/m/tilt/internal/controllers/core/cmd"
	"github.com/defn/dev/m/tilt/internal/controllers/core/cmdimage"
	"github.com/defn/dev/m/tilt/internal/controllers/core/configmap"
	"github.com/defn/dev/m/tilt/internal/controllers/core/dockercomposelogstream"
	"github.com/defn/dev/m/tilt/internal/controllers/core/dockercomposeservice"
	"github.com/defn/dev/m/tilt/internal/controllers/core/dockerimage"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extension"
	"github.com/defn/dev/m/tilt/internal/controllers/core/extensionrepo"
	"github.com/defn/dev/m/tilt/internal/controllers/core/filewatch"
	"github.com/defn/dev/m/tilt/internal/controllers/core/imagemap"
	"github.com/defn/dev/m/tilt/internal/controllers/core/kubernetesapply"
	"github.com/defn/dev/m/tilt/internal/controllers/core/kubernetesdiscovery"
	"github.com/defn/dev/m/tilt/internal/controllers/core/liveupdate"
	"github.com/defn/dev/m/tilt/internal/controllers/core/podlogstream"
	"github.com/defn/dev/m/tilt/internal/controllers/core/portforward"
	"github.com/defn/dev/m/tilt/internal/controllers/core/session"
	"github.com/defn/dev/m/tilt/internal/controllers/core/tiltfile"
	"github.com/defn/dev/m/tilt/internal/controllers/core/togglebutton"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uibutton"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uiresource"
	"github.com/defn/dev/m/tilt/internal/controllers/core/uisession"
	"github.com/defn/dev/m/tilt/internal/k8s/kubeconfig"
)

var controllerSet = wire.NewSet(
	filewatch.NewController,
	kubernetesdiscovery.NewReconciler,
	portforward.NewReconciler,
	podlogstream.NewController,
	podlogstream.NewPodSource,
	kubernetesapply.NewReconciler,
	cluster.NewReconciler,
	kubeconfig.NewWriter,

	ProvideControllers,
)

func ProvideControllers(
	fileWatch *filewatch.Controller,
	cmds *cmd.Controller,
	podlogstreams *podlogstream.Controller,
	kubernetesDiscovery *kubernetesdiscovery.Reconciler,
	kubernetesApply *kubernetesapply.Reconciler,
	uis *uisession.Reconciler,
	uir *uiresource.Reconciler,
	uib *uibutton.Reconciler,
	pfr *portforward.Reconciler,
	tfr *tiltfile.Reconciler,
	tbr *togglebutton.Reconciler,
	extr *extension.Reconciler,
	extrr *extensionrepo.Reconciler,
	lur *liveupdate.Reconciler,
	cmr *configmap.Reconciler,
	dir *dockerimage.Reconciler,
	cir *cmdimage.Reconciler,
	clr *cluster.Reconciler,
	dcr *dockercomposeservice.Reconciler,
	imr *imagemap.Reconciler,
	dclsr *dockercomposelogstream.Reconciler,
	sr *session.Reconciler,
) []Controller {
	return []Controller{
		fileWatch,
		cmds,
		podlogstreams,
		kubernetesDiscovery,
		kubernetesApply,
		uis,
		uir,
		uib,
		pfr,
		tfr,
		tbr,
		extr,
		extrr,
		lur,
		cmr,
		dir,
		cir,
		clr,
		dcr,
		imr,
		dclsr,
		sr,
	}
}

var WireSet = wire.NewSet(
	NewTiltServerControllerManager,

	NewControllerBuilder,
	ProvideUncachedObjects,

	ProvideDeferredClient,
	wire.Bind(new(ctrlclient.Client), new(*DeferredClient)),

	cluster.WireSet,
	cmd.WireSet,
	controllerSet,
	uiresource.WireSet,
	uisession.WireSet,
	uibutton.WireSet,
	togglebutton.WireSet,
	tiltfile.WireSet,
	extensionrepo.WireSet,
	extension.WireSet,
	liveupdate.WireSet,
	configmap.WireSet,
	dockerimage.WireSet,
	cmdimage.WireSet,
	dockercomposeservice.WireSet,
	imagemap.WireSet,
	dockercomposelogstream.WireSet,
	session.WireSet,
)
