package tiltfile

import (
	"context"
	"fmt"
	"time"

	"github.com/google/go-cmp/cmp"
	"k8s.io/apimachinery/pkg/api/meta"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/apimachinery/pkg/util/errors"
	"sigs.k8s.io/controller-runtime/pkg/cache"
	ctrlclient "sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"

	"github.com/defn/dev/m/tilt/internal/controllers/apicmp"
	"github.com/defn/dev/m/tilt/internal/controllers/apiset"
	"github.com/defn/dev/m/tilt/internal/controllers/indexer"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/internal/store/sessions"
	"github.com/defn/dev/m/tilt/internal/tiltfile"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
	"github.com/defn/dev/m/tilt/pkg/model"
)

var (
	apiGVStr = v1alpha1.SchemeGroupVersion.String()
	apiKind  = "Tiltfile"
	apiType  = metav1.TypeMeta{Kind: apiKind, APIVersion: apiGVStr}
)

// Update all the objects in the apiserver that are owned by the Tiltfile.
//
// Here we have one big API object (the Tiltfile loader) create lots of
// API objects of different types. This is not a common pattern in Kubernetes-land
// (where often each type will only own one or two other types). But it's the best way
// to model how the Tiltfile works.
//
// For that reason, this code is much more generic than owned-object creation should be.
//
// In the future, anything that creates objects based on the Tiltfile (e.g., FileWatch specs,
// LocalServer specs) should go here.
func updateOwnedObjects(
	ctx context.Context,
	client ctrlclient.Client,
	nn types.NamespacedName,
	tf *v1alpha1.Tiltfile,
	tlr *tiltfile.TiltfileLoadResult,
	ciTimeoutFlag model.CITimeoutFlag,
	mode store.EngineMode,
) error {
	apiObjects := toAPIObjects(nn, tf, tlr, ciTimeoutFlag, mode)

	// Propagate labels and owner references from the parent tiltfile.
	for _, objMap := range apiObjects {
		for _, obj := range objMap {
			err := controllerutil.SetControllerReference(tf, obj, client.Scheme())
			if err != nil {
				return err
			}
			propagateLabels(tf, obj)
			propagateAnnotations(tf, obj)
		}
	}

	// Retry until the cache has started.
	var retryCount = 0
	var existingObjects apiset.ObjectSet
	var err error
	for {
		existingObjects, err = getExistingAPIObjects(ctx, client, nn)
		if err != nil {
			if _, ok := err.(*cache.ErrCacheNotStarted); ok && retryCount < 5 {
				retryCount++
				time.Sleep(200 * time.Millisecond)
				continue
			}
			return err
		}
		break
	}

	err = updateNewObjects(ctx, client, apiObjects, existingObjects)
	if err != nil {
		return err
	}

	// If the tiltfile loader succeeded or if the tiltfile was deleted,
	// garbage collect any old objects.
	//
	// If the tiltfile loader failed, we want to keep those objects around, in case
	// the tiltfile was only partially evaluated and is missing objects.
	if tlr == nil || tlr.Error == nil {
		err := removeOrphanedObjects(ctx, client, apiObjects, existingObjects)
		if err != nil {
			return err
		}
	}
	return nil
}

// Apply labels from the Tiltfile to all objects it creates.
func propagateLabels(tf *v1alpha1.Tiltfile, obj apiset.Object) {
	if len(tf.Spec.Labels) > 0 {
		labels := obj.GetLabels()
		if labels == nil {
			labels = make(map[string]string)
		}
		for k, v := range tf.Spec.Labels {
			// Labels specified during tiltfile execution take precedence over
			// labels specified in the tiltfile spec.
			_, exists := labels[k]
			if !exists {
				labels[k] = v
			}
		}
		obj.SetLabels(labels)
	}
}

// We don't have a great strategy right now for assigning
// API object spec definitions to Manifests in the Tilt UI.
//
// For now, if an object doesn't have a Manifest annotation
// defined, we give it the same Manifest as the parent Tiltfile.
func propagateAnnotations(tf *v1alpha1.Tiltfile, obj apiset.Object) {
	annos := obj.GetAnnotations()
	if annos[v1alpha1.AnnotationManifest] == "" {
		if annos == nil {
			annos = make(map[string]string)
		}
		annos[v1alpha1.AnnotationManifest] = tf.Name
		obj.SetAnnotations(annos)
	}
}

var typesWithTiltfileBuiltins = []apiset.Object{
	&v1alpha1.ExtensionRepo{},
	&v1alpha1.Extension{},
	&v1alpha1.FileWatch{},
	&v1alpha1.Cmd{},
	&v1alpha1.ConfigMap{},
}

var typesToReconcile = append([]apiset.Object{
	&v1alpha1.Session{},
}, typesWithTiltfileBuiltins...)

// Fetch all the existing API objects that were generated from the Tiltfile.
func getExistingAPIObjects(ctx context.Context, client ctrlclient.Client, nn types.NamespacedName) (apiset.ObjectSet, error) {
	result := apiset.ObjectSet{}

	// TODO(nick): Parallelize this?
	for _, obj := range typesToReconcile {
		list := obj.NewList().(ctrlclient.ObjectList)
		err := indexer.ListOwnedBy(ctx, client, list, nn, apiType)
		if err != nil {
			return nil, err
		}

		_ = meta.EachListItem(list, func(obj runtime.Object) error {
			result.Add(obj.(apiset.Object))
			return nil
		})
	}

	return result, nil
}

// Pulls out all the API objects generated by the Tiltfile.
func toAPIObjects(
	nn types.NamespacedName,
	tf *v1alpha1.Tiltfile,
	tlr *tiltfile.TiltfileLoadResult,
	ciTimeoutFlag model.CITimeoutFlag,
	mode store.EngineMode,
) apiset.ObjectSet {
	result := apiset.ObjectSet{}

	if tlr != nil {
		for _, obj := range typesWithTiltfileBuiltins {
			result.AddSetForType(obj, tlr.ObjectSet.GetSetForType(obj))
		}

		result.AddSetForType(&v1alpha1.Cmd{}, toCmdObjects(tlr))
	}

	result.AddSetForType(&v1alpha1.Session{}, toSessionObjects(nn, tf, tlr, ciTimeoutFlag, mode))

	watchInputs := WatchInputs{
		TiltfileManifestName: model.ManifestName(nn.Name),
		EngineMode:           mode,
	}

	if tlr != nil {
		watchInputs.Manifests = tlr.Manifests
		watchInputs.ConfigFiles = tlr.ConfigFiles
		watchInputs.Tiltignore = tlr.Tiltignore
		watchInputs.WatchSettings = tlr.WatchSettings
	}

	if tf != nil {
		watchInputs.TiltfilePath = tf.Spec.Path
	}

	result.AddSetForType(&v1alpha1.FileWatch{}, ToFileWatchObjects(watchInputs))

	return result
}

// Creates an object representing the tilt session and exit conditions.
func toSessionObjects(nn types.NamespacedName, tf *v1alpha1.Tiltfile, tlr *tiltfile.TiltfileLoadResult, ciTimeoutFlag model.CITimeoutFlag, mode store.EngineMode) apiset.TypedObjectSet {
	result := apiset.TypedObjectSet{}
	if nn.Name != model.MainTiltfileManifestName.String() {
		return result
	}
	result[sessions.DefaultSessionName] = sessions.FromTiltfile(tf, tlr, ciTimeoutFlag, mode)
	return result
}

// Pulls out all the Cmd objects generated by the Tiltfile.
func toCmdObjects(tlr *tiltfile.TiltfileLoadResult) apiset.TypedObjectSet {
	result := apiset.TypedObjectSet{}

	// Every local_resource's Update Cmd gets its own object.
	for _, m := range tlr.Manifests {
		if !m.IsLocal() {
			continue
		}
		localTarget := m.LocalTarget()
		cmdSpec := localTarget.UpdateCmdSpec
		if cmdSpec == nil {
			continue
		}

		name := localTarget.UpdateCmdName()
		cmd := &v1alpha1.Cmd{
			ObjectMeta: metav1.ObjectMeta{
				Name: name,
				Annotations: map[string]string{
					v1alpha1.AnnotationManifest:  m.Name.String(),
					v1alpha1.AnnotationSpanID:    fmt.Sprintf("cmd:%s", name),
					v1alpha1.AnnotationManagedBy: "local_resource",
				},
			},
			Spec: *cmdSpec,
		}
		result[name] = cmd
	}

	return result
}

func needsUpdate(old, obj apiset.Object) bool {
	// Are there other fields here we should check?
	specChanged := !apicmp.DeepEqual(old.GetSpec(), obj.GetSpec())
	labelsChanged := !apicmp.DeepEqual(old.GetLabels(), obj.GetLabels())
	annsChanged := !apicmp.DeepEqual(old.GetAnnotations(), obj.GetAnnotations())
	if specChanged || labelsChanged || annsChanged {
		return true
	}

	// if this section ends up with more type-specific checks, we should probably move this
	// to be a method on apiset.Object
	if cm, ok := obj.(*v1alpha1.ConfigMap); ok {
		if !cmp.Equal(cm.Data, old.(*v1alpha1.ConfigMap).Data) {
			return true
		}
	}

	return false
}

// Reconcile the new API objects against the existing API objects.
func updateNewObjects(ctx context.Context, client ctrlclient.Client, newObjects, oldObjects apiset.ObjectSet) error {
	// TODO(nick): Does it make sense to parallelize the API calls?
	errs := []error{}

	// Upsert the new objects.
	for t, s := range newObjects {
		for name, obj := range s {
			var old apiset.Object
			oldSet, ok := oldObjects[t]
			if ok {
				old = oldSet[name]
			}

			if old == nil {
				err := client.Create(ctx, obj)
				if err != nil {
					errs = append(errs, fmt.Errorf("create %s/%s: %v", obj.GetGroupVersionResource().Resource, obj.GetName(), err))
				}
				continue
			}

			if needsUpdate(old, obj) {
				obj.SetResourceVersion(old.GetResourceVersion())
				err := client.Update(ctx, obj)
				if err != nil {
					errs = append(errs, fmt.Errorf("update %s/%s: %v", obj.GetGroupVersionResource().Resource, obj.GetName(), err))
				}
				continue
			}
		}
	}
	return errors.NewAggregate(errs)
}

// Garbage collect API objects that are no longer loaded.
func removeOrphanedObjects(ctx context.Context, client ctrlclient.Client, newObjects, oldObjects apiset.ObjectSet) error {
	// Delete any objects that aren't in the new tiltfile.
	errs := []error{}
	for t, s := range oldObjects {
		for name, obj := range s {
			newSet, ok := newObjects[t]
			if ok {
				_, ok := newSet[name]
				if ok {
					continue
				}
			}

			err := client.Delete(ctx, obj)
			if err != nil {
				errs = append(errs, fmt.Errorf("delete %s/%s: %v", obj.GetGroupVersionResource().Resource, obj.GetName(), err))
			}
		}
	}
	return errors.NewAggregate(errs)
}
