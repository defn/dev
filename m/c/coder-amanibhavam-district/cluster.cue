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
	"coder-school": {}
	"coder-ingress": {}
	"argocd-district": {}
	"argocd-school": {}
	"argocd-ingress": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
