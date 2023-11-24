package c

teacher: bootstrap: k3s_bootstrap & {
	"postgres-operator": {}
	"harbor": {}

	"tfo": {}
	"argo-workflows": {}
	"argo-events": {}

	"headlamp": {}
}

class: {
	handle:          "amanibhavam"
	env:             "district"
	infra_cilium_id: 250
}
