package c

teacher: bootstrap: k3s_bootstrap & {
	"tfo": {}
	"buildkite": {}
	"harbor": {}
	"headlamp": {}
	"traefik": {}
	"external-dns": {}
	"crossdemo": {}
	"deathstar": {}
	"coder-global": {}
	"coder-ingress": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
