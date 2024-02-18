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
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
