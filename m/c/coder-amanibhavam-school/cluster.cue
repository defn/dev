package c

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}

teacher: bootstrap: k3s_bootstrap & {
	"crossdemo": {}
	"xwing": {}

	"postgres-operator": {}
	"coder": {}
	"argocd-school": {}
	"coder-school": {}
}
