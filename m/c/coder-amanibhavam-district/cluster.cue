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
	cluster_ip:      "172.31.44.38"
	infra_cilium_id: 250
}
