package uisession

import (
	"context"
	"fmt"

	"sigs.k8s.io/controller-runtime/pkg/builder"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	ctrl "sigs.k8s.io/controller-runtime"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"

	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// The uisession.Reconciler watches UISession objects.
type Reconciler struct {
	client ctrlclient.Client
}

var _ reconcile.Reconciler = &Reconciler{}

func NewReconciler(client ctrlclient.Client) *Reconciler {
	return &Reconciler{
		client: client,
	}
}

func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	session := &v1alpha1.UISession{}
	err := r.client.Get(ctx, req.NamespacedName, session)
	if err != nil && !apierrors.IsNotFound(err) {
		return ctrl.Result{}, fmt.Errorf("uisession reconcile: %v", err)
	}

	if apierrors.IsNotFound(err) || session.ObjectMeta.DeletionTimestamp != nil {
		// NOTE(nick): This should never happen, and if it does, Tilt should
		// immediately re-create the session.
		return ctrl.Result{}, nil
	}

	return ctrl.Result{}, nil
}

func (r *Reconciler) CreateBuilder(mgr ctrl.Manager) (*builder.Builder, error) {
	b := ctrl.NewControllerManagedBy(mgr).
		For(&v1alpha1.UISession{})

	return b, nil
}
