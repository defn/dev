package uibutton

import (
	"testing"

	"github.com/stretchr/testify/assert"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"

	"github.com/defn/dev/m/tilt/internal/controllers/fake"
	"github.com/defn/dev/m/tilt/internal/hud/server"
	"github.com/defn/dev/m/tilt/internal/store"
	"github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"
)

func TestDefault(t *testing.T) {
	f := newFixture(t)

	b := v1alpha1.UIButton{
		ObjectMeta: metav1.ObjectMeta{
			Name: "my-button",
		},
		Spec: v1alpha1.UIButtonSpec{
			Text: "Hello world!",
		},
	}
	f.Create(&b)

	f.MustGet(types.NamespacedName{Name: "my-button"}, &b)
	assert.Equal(t, "dbcfa71870a98e800b0a", b.Annotations[annotationSpecHash])
	f.assertSteadyState(&b)
}

type fixture struct {
	*fake.ControllerFixture
	r *Reconciler
}

func newFixture(t *testing.T) *fixture {
	cfb := fake.NewControllerFixtureBuilder(t)
	st := store.NewTestingStore()
	r := NewReconciler(cfb.Client, server.NewWebsocketList(), st)
	return &fixture{
		ControllerFixture: cfb.Build(r),
		r:                 r,
	}
}

func (f *fixture) assertSteadyState(b *v1alpha1.UIButton) {
	f.T().Helper()
	f.MustReconcile(types.NamespacedName{Name: b.Name})
	var b2 v1alpha1.UIButton
	f.MustGet(types.NamespacedName{Name: b.Name}, &b2)
	assert.Equal(f.T(), b.ResourceVersion, b2.ResourceVersion)
}
