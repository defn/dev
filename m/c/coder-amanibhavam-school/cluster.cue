package c

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"coder": {}
	"argocd-school": {}
	"coder-school": {}

	"crossdemo": {}
	"xwing": {}
}

kustomize: coder: helm: namespace: "coder-\(class.env)"
