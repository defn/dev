package c

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"coder": {}
	"crossdemo": {}
	"xwing": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}
