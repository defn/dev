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
	discovery_url:   "https://d2br8g5o2i66an.cloudfront.net"
}
