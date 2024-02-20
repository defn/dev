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
	"coder-global-school": {}
	"coder-ingress": {}
	"argocd-global-district": {}
	"argocd-global-school": {}
	"argocd-ingress": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
