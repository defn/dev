package c

class: {
	handle:             "amanibhavam"
	env:                "school"
	infra_cilium_id:    200
	infra_cidr_16:      "10.\(infra_cilium_id)"
	infra_pod_cidr:     "\(infra_cidr_16).0.0/17"
	infra_service_cidr: "\(infra_cidr_16).128.0/17"
}
