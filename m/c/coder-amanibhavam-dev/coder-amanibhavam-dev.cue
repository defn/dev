package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
}

class: {
	handle:             "amanibhavam"
	env:                "dev"
	infra_cilium_id:    0
	infra_cidr_16:      "10.\(infra_cilium_id)"
	infra_pod_cidr:     "\(infra_cidr_16).0.0/17"
	infra_service_cidr: "\(infra_cidr_16).128.0/17"
}
