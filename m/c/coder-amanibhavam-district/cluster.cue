package c

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}

teacher: bootstrap: k3s_bootstrap & {
	"buildkite": {}
	"harbor": {}
	"external-dns": {}

	"postgres-operator": {}
	"coder": {}

	"traefik": {}
	"argocd-ingress": {}
	"coder-ingress": {}

	"argocd-district": {}
	"coder-district": {}

	"argocd-school": {}
	"coder-school": {}

	"deathstar": {}

}

kustomize: cilium: helm: values: hubble: ui: enabled: true
kustomize: coder: helm: namespace: "coder-\(class.env)"
