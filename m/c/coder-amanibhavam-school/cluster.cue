package c

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"crossdemo": {}
	"xwing": {}
	"coder": {}
	"coder-school": {}
	"argocd-school": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}
