package r

import (
	core "k8s.io/api/core/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"
	batch "k8s.io/api/batch/v1"
	policy "k8s.io/api/policy/v1"
	networking "k8s.io/api/networking/v1"
	autoscaling "k8s.io/api/autoscaling/v2"
	admissionregistration "k8s.io/api/admissionregistration/v1"

	"github.com/defn/dev/m/k/r"
)

// by kind
kk: r.res
kk: "deployment": [string]: [string]:  apps.#Deployment
kk: "statefulset": [string]: [string]: apps.#StatefulSet
kk: "daemonset": [string]: [string]:   apps.#DaemonSet

kk: "clusterrolebinding": [string]: [string]: rbac.#ClusterRoleBinding
kk: "clusterrole": [string]: [string]:        rbac.#ClusterRole
kk: "rolebinding": [string]: [string]:        rbac.#RoleBinding
kk: "role": [string]: [string]:               rbac.#Role

//kk: "secret": [string]: [string]:     core.#Secret
kk: "namespace": [NS=string]: [RES=string]:      core.#Namespace
kk: "pod": [string]: [string]:                   core.#Pod
kk: "persistentvolumeclaim": [string]: [string]: core.#PersistentVolumeClaim
kk: "configmap": [string]: [string]:             core.#ConfigMap
kk: "serviceaccount": [string]: [string]:        core.#ServiceAccount

kk: "job": [string]: [string]:     batch.#Job
kk: "cronjob": [string]: [string]: batch.#CronJob

kk: "horizontalpodautoscaler": [string]: [string]: autoscaling.#HorizontalPodAutoscaler

kk: "ingress": [string]: [string]:       networking.#Ingress
kk: "networkpolicy": [string]: [string]: networking.#NetworkPolicy
kk: "ingressclass": [string]: [string]:  networking.#IngressClass

kk: "validatingwebhookconfiguration": [string]: [string]: admissionregistration.#ValidatingWebhookConfiguration
kk: "mutatingwebhookconfiguration": [string]: [string]:   admissionregistration.#MutatingWebhookConfiguration

kk: "poddisruptionbudget": [string]: [string]: policy.#PodDisruptionBudget

// by namespace
nn: [NS=string]: [KIND=string]: [RES=string]: {...}
nn: {
	for kname, k in kk
	for nname, ns in k
	for rname, r in ns {
		"\(nname)": "\(kname)": "\(rname)": r
	}
}

// flatten resources into a map
resources: {
	for kname, k in kk
	for nname, ns in k
	for rname, r in ns {
		"\(nname)-\(kname)-\(rname)": r
	}
}

// get images for Deployments, Daemonsets
images_m: {
	for rname, r in resources
	if r.kind == "Deployment" || r.kind == "DaemonSet" || r.kind == "StatefulSet" || r.kind == "Job" || r.kind == "CronJob" {
		for c in *r.spec.template.spec.containers | r.spec.jobTemplate.spec.template.spec.containers {
			"\(c.image)": {}
		}
	}
}

// flatten list of images
images: [
	for i, _ in images_m {i},
]
