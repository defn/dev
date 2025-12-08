package uibutton

import (
	"context"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/builder"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"

	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/store/uibuttons"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

type Reconciler struct {
	client     ctrlclient.Client
	dispatcher store.Dispatcher
}

var _ reconcile.Reconciler = &Reconciler{}

func NewReconciler(client ctrlclient.Client, store store.RStore) *Reconciler {
	return &Reconciler{
		client:     client,
		dispatcher: store,
	}
}

func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	button := &v1alpha1.UIButton{}
	err := r.client.Get(ctx, req.NamespacedName, button)
	if err != nil && !apierrors.IsNotFound(err) {
		return ctrl.Result{}, fmt.Errorf("uibutton reconcile: %v", err)
	}

	if apierrors.IsNotFound(err) || button.ObjectMeta.DeletionTimestamp != nil {
		r.dispatcher.Dispatch(uibuttons.NewUIButtonDeleteAction(req.Name))
		return ctrl.Result{}, nil
	}

	// The apiserver is the source of truth, and will ensure the engine state is up to date.
	r.dispatcher.Dispatch(uibuttons.NewUIButtonUpsertAction(button))

	// Add an annotation to each button that hashes the spec,
	// so that we can determine that a button is unique.
	hash, err := hashUIButtonSpec(button.Spec)
	if err == nil && hash != button.Annotations[annotationSpecHash] {
		update := button.DeepCopy()
		if update.Annotations == nil {
			update.Annotations = make(map[string]string)
		}
		update.Annotations[annotationSpecHash] = hash
		err := r.client.Update(ctx, update)
		if err != nil {
			return ctrl.Result{}, nil
		}
		button = update
	}

	return ctrl.Result{}, nil
}

func (r *Reconciler) CreateBuilder(mgr ctrl.Manager) (*builder.Builder, error) {
	b := ctrl.NewControllerManagedBy(mgr).
		For(&v1alpha1.UIButton{})

	return b, nil
}
