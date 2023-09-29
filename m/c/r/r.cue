package r

import (
	"github.com/defn/dev/m/k/r" // resources monoconfig
)

// flatten resources into a map
resources: {
	for kname, k in r.res
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
