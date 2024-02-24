package c

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}

teacher: bootstrap: k3s_bootstrap & {
	"buildkite": {}
	"harbor": {}
	"headlamp": {}
	"external-dns": {}
	"deathstar": {}

	"postgres-operator": {}
	"coder": {}

	"traefik": {}
	"argocd-ingress": {}
	"coder-ingress": {}

	"argocd-district": {}
	"coder-district": {}

	"argocd-school": {}
	"coder-school": {}
}

kustomize: "cilium": helm: values: hubble: ui: enabled: true
