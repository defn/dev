package c

teacher: {
	bootstrap: {
		// build
		"harbor": [100, ""]

		// workflows
		"tfo": [100, ""]
		"argo-workflows": [100, ""]
		"argo-events": [100, ""]

		// applications
		"headlamp": [100, ""]
		"postgres-operator": [100, ""]
		"hello": [100, ""]
	}
}

class: {
	handle: "amanibhavam"
	env:    "district"
	infra_cilium_id:    250
	infra_cidr_16: "10.\(infra_cilium_id)"
	infra_pod_cidr:     "\(infra_cidr_16).0.0/17"
	infra_service_cidr: "\(infra_cidr_16).128.0/17"
}
