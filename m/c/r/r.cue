package r

import (
	core "k8s.io/api/core/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"

	"github.com/defn/dev/m/k/r"
)

// by kind
kk: r
kk: "namespace": [NS=string]: [RES=string]:   core.#Namespace
kk: "deployment": [string]: [string]:         apps.#Deployment
kk: "statefulset": [string]: [string]:        apps.#StatefulSet
kk: "daemonset": [string]: [string]:          apps.#DaemonSet
kk: "clustekkolebinding": [string]: [string]: rbac.#ClustekkoleBinding
kk: "clustekkole": [string]: [string]:        rbac.#Clustekkole
kk: "rolebinding": [string]: [string]:        rbac.#RoleBinding
kk: "role": [string]: [string]:               rbac.#Role

// by namespace
nn: [NS=string]: [KIND=string]: [RES=string]: {...}
nn: {
	for kname, k in kk.res
	for nname, ns in k
	for rname, r in ns {
		"\(nname)": "\(kname)": "\(rname)": r
	}
}

// flatten resources into a map
resources: {
	for kname, k in kk.res
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
