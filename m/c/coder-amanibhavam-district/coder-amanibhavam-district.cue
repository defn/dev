package c

teacher_handle:     "amanibhavam"
teacher_env:        "district"
infra_cilium_id:    250
infra_pod_cidr:     "10.250.0.0/17"
infra_service_cidr: "10.250.128.0/17"

infra_workloads: {
	// workflows
	"tfo": [100, ""]
	"argo-workflows": [100, ""]
	"argo-events": [100, ""]

	// applications
	"headlamp": [100, ""]
	"postgres-operator": [100, ""]
	"hello": [100, ""]
}
