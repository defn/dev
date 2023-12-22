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

	"github.com/defn/dev/m/c/k/y"
)

// by kind
xx: y.res

xx: "deployment": [string]: [string]: [string]:  apps.#Deployment & {apiVersion:  "apps/v1"}
xx: "statefulset": [string]: [string]: [string]: apps.#StatefulSet & {apiVersion: "apps/v1"}
xx: "daemonset": [string]: [string]: [string]:   apps.#DaemonSet & {apiVersion:   "apps/v1"}

xx: "clusterrolebinding": [string]: [string]: [string]: rbac.#ClusterRoleBinding & {apiVersion: "rbac.authorization.k8s.io/v1"}
xx: "clusterrole": [string]: [string]: [string]:        rbac.#ClusterRole & {apiVersion:        "rbac.authorization.k8s.io/v1"}
xx: "rolebinding": [string]: [string]: [string]:        rbac.#RoleBinding & {apiVersion:        "rbac.authorization.k8s.io/v1"}
xx: "role": [string]: [string]: [string]:               rbac.#Role & {apiVersion:               "rbac.authorization.k8s.io/v1"}

//xx: "secret": [string]: [string]: [string]:     core.#Secret
xx: "namespace": [string]: [NS=string]: [RES=string]:      core.#Namespace & {apiVersion:             "v1"}
xx: "pod": [string]: [string]: [string]:                   core.#Pod & {apiVersion:                   "v1"}
xx: "persistentvolumeclaim": [string]: [string]: [string]: core.#PersistentVolumeClaim & {apiVersion: "v1"}
xx: "configmap": [string]: [string]: [string]:             core.#ConfigMap & {apiVersion:             "v1"}
xx: "serviceaccount": [string]: [string]: [string]:        core.#ServiceAccount & {apiVersion:        "v1"}

xx: "job": [string]: [string]: [string]:     batch.#Job & {apiVersion:     "batch/v1"}
xx: "cronjob": [string]: [string]: [string]: batch.#CronJob & {apiVersion: "batch/v1"}

xx: "horizontalpodautoscaler": [string]: [string]: [string]: autoscaling.#HorizontalPodAutoscaler & {apiVersion: "autoscaling/v2"}

xx: "ingress": [string]: [string]: [string]:       networking.#Ingress & {apiVersion:       "networking.k8s.io/v1"}
xx: "networkpolicy": [string]: [string]: [string]: networking.#NetworkPolicy & {apiVersion: "networking.k8s.io/v1"}
xx: "ingressclass": [string]: [string]: [string]:  networking.#IngressClass & {apiVersion:  "networking.k8s.io/v1"}

xx: "validatingwebhookconfiguration": [string]: [string]: [string]: admissionregistration.#ValidatingWebhookConfiguration & {apiVersion: "admissionregistration.k8s.io/v1"}
xx: "mutatingwebhookconfiguration": [string]: [string]: [string]:   admissionregistration.#MutatingWebhookConfiguration & {apiVersion:   "admissionregistration.k8s.io/v1"}

xx: "poddisruptionbudget": [string]: [string]: [string]: policy.#PodDisruptionBudget & {apiVersion: "policy/v1"}

kk: y.res

// flatten resources into a map
resources: {
	for kname, k in kk
	for fname, f in k
	for nname, ns in f
	for rname, r in ns {
		(fname): "\(nname)--\(kname)--\(rname)": r
	}
}

images_m: {
	for fname, f in resources
	for rname, r in f {
		if r.spec.jobTemplate.spec.template.spec.containers != _|_ {
			for c in r.spec.jobTemplate.spec.template.spec.containers {
				(c.image): {}
			}
		}

		if r.spec.jobTemplate.spec.template.spec.initContainers != _|_ {
			for c in r.spec.jobTemplate.spec.template.spec.initContainers {
				(c.image): {}
			}
		}

		if r.spec.template.spec.containers != _|_ {
			for c in r.spec.template.spec.containers {
				(c.image): {}
			}
		}

		if r.spec.template.spec.initContainers != _|_ {
			for c in r.spec.template.spec.initContainers {
				(c.image): {}
			}
		}

		if r.spec.containers != _|_ {
			for c in r.spec.containers {
				(c.image): {}
			}
		}

		if r.spec.image != _|_ {
			(r.spec.image): {}
		}

	}
}

// flatten list of images
images: [
	for i, _ in images_m {i},
]
