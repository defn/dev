package c

teacher: bootstrap: k3s_bootstrap & {
	// build
	"harbor": {}

	// workflows
	"tfo": {}
	"argo-workflows": {}
	"argo-events": {}

	// applications
	"headlamp": {}
	"postgres-operator": {}
	"hello": {}
}

class: {
	handle:             "amanibhavam"
	env:                "district"
	infra_cilium_id:    250
	infra_cidr_16:      "10.\(infra_cilium_id)"
	infra_pod_cidr:     "\(infra_cidr_16).0.0/17"
	infra_service_cidr: "\(infra_cidr_16).128.0/17"
}
