package c

teacher: bootstrap: k3s_bootstrap & {
	"buildkite": {}
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
