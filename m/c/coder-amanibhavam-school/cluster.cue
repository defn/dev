package c

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"crossdemo": {}
	"xwing": {}
	"argocd-school": {}
	"coder-school": {}
}
