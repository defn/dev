package uiresource

import (
	"context"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/builder"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/store/uiresources"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

// The uiresource.Reconciler watches UIResource objects and updates the store.
type Reconciler struct {
	client ctrlclient.Client
	store  store.RStore
}

var _ reconcile.Reconciler = &Reconciler{}

func NewReconciler(client ctrlclient.Client, store store.RStore) *Reconciler {
	return &Reconciler{
		client: client,
		store:  store,
	}
}

func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	resource := &v1alpha1.UIResource{}
	err := r.client.Get(ctx, req.NamespacedName, resource)
	if err != nil && !apierrors.IsNotFound(err) {
		return ctrl.Result{}, fmt.Errorf("uiresource reconcile: %v", err)
	}

	if apierrors.IsNotFound(err) || resource.ObjectMeta.DeletionTimestamp != nil {
		r.store.Dispatch(uiresources.NewUIResourceDeleteAction(req.Name))
		return ctrl.Result{}, nil
	}

	r.store.Dispatch(uiresources.NewUIResourceUpsertAction(resource))

	return ctrl.Result{}, nil
}

func (r *Reconciler) CreateBuilder(mgr ctrl.Manager) (*builder.Builder, error) {
	b := ctrl.NewControllerManagedBy(mgr).
		For(&v1alpha1.UIResource{})

	return b, nil
}
