package c

teacher: bootstrap: k3s_bootstrap & {
	"knative": {}
	"kourier": {}

	"harbor": {}

	"tfo": {}
	"argo-workflows": {}
	"argo-events": {}
	"buildkite": {}

	"headlamp": {}

	"pihole": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
