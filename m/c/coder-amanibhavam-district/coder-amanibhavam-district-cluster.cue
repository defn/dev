package c

teacher: bootstrap: k3s_bootstrap & {
	"tfo": {}
	"buildkite": {}
	"harbor": {}
	"headlamp": {}
	"tailscale": {}
	"traefik": {}
	"external-dns": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
