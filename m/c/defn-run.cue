package c

teacher_handle: string
teacher_env:    string

teacher_bootstrap: {
	// essentials
	"kyverno": [2, "", "ServerSideApply=true"]
	"cert-manager": [2, ""]

	"trust-manager": [10, ""]

	// external secrets
	"pod-identity": [10, ""]
	"external-secrets": [11, ""]
	"secrets": [12, ""]

	// tailscale
	"tailscale": [20, ""]

	// scaling
	"karpenter": [20, ""]

	// workflows
	"tfo": [20, ""]
	"argo-workflows": [20, ""]
	"argo-events": [20, ""]

	// external dns, certs issuer
	"external-dns": [20, ""]
	"issuer": [20, ""]

	// traefik, functions
	"knative": [40, ""]
	"kourier": [40, ""]
	"traefik": [40, ""]

	// applications
	"headlamp": [100, ""]
	"postgres-operator": [100, ""]
	//"coder": [100, ""]
}

infra_alt_name:    string | *infra_name
infra_account_id:  "510430971399"
infra_k3s_version: "rancher/k3s:v1.27.5-k3s1"

infra_name: string | *"coder-\(teacher_handle)-\(teacher_env)"

infra_pod_cidr:     string
infra_service_cidr: string
infra_cilium_name: string | *infra_name
infra_cilium_id: int
infra_cilium_id: >= 0
infra_cilium_id: <= 255

infra_vclusters: []

infra_base: {
	domain_name: "\(teacher_env).\(teacher_handle).defn.run"
	domain_slug: "\(teacher_env)-\(teacher_handle)-defn-run"
}

infra_base: {
	domain_zone: "defn.run"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	cloudflare_email: "cloudflare@defn.us"
}

infra: "\(infra_name)": bootstrap: {...} | *teacher_bootstrap

discovery_url: string | *"https://\(infra_alt_name).tail3884f.ts.net"
