package kubernetesapplys

import "github.com/defn/dev/m/tilt/pkg/apis/core/v1alpha1"

type KubernetesApplyUpsertAction struct {
	KubernetesApply *v1alpha1.KubernetesApply
}

func NewKubernetesApplyUpsertAction(obj *v1alpha1.KubernetesApply) KubernetesApplyUpsertAction {
	return KubernetesApplyUpsertAction{KubernetesApply: obj}
}

func (KubernetesApplyUpsertAction) Action() {}

type KubernetesApplyDeleteAction struct {
	Name string
}

func NewKubernetesApplyDeleteAction(n string) KubernetesApplyDeleteAction {
	return KubernetesApplyDeleteAction{Name: n}
}

func (KubernetesApplyDeleteAction) Action() {}
