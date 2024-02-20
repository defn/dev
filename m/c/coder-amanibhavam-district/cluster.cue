package c

teacher: bootstrap: k3s_bootstrap & {
	"tfo": {}
	"buildkite": {}
	"harbor": {}
	"headlamp": {}
	"external-dns": {}
	"crossdemo": {}
	"deathstar": {}

	"traefik": {}
	"coder-global": {}
	"coder-ingress": {}
	"argocd-ingress": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
