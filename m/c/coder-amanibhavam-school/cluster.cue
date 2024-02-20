package c

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"crossdemo": {}
	"xwing": {}
	"coder": {}
	"coder-global-school": {}
	"argocd-global-school": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}
