package c

teacher: bootstrap: k3s_bootstrap & {
	"tfo": {}
	"argo-workflows": {}
	"argo-events": {}
	"buildkite": {}
	"harbor": {}

	"headlamp": {}

	"pihole": {}

	"tailscale": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
