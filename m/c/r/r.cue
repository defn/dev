package r

import (
	core "k8s.io/api/core/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"

	"github.com/defn/dev/m/k/r"
)

rr: r

rr: "namespace": [string]: [string]: core.#Namespace
rr: "deployment": [string]: [string]: apps.#Deployment
rr: "statefulset": [string]: [string]: apps.#StatefulSet
rr: "daemonset": [string]: [string]: apps.#DaemonSet
rr: "clusterrolebinding": [string]: [string]: rbac.#ClusterRoleBinding
rr: "clusterrole": [string]: [string]: rbac.#ClusterRole
rr: "rolebinding": [string]: [string]: rbac.#RoleBinding
rr: "role": [string]: [string]: rbac.#Role

// flatten resources into a map
resources: {
	for kname, k in rr.res
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
