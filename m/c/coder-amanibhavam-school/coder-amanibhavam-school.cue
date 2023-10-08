package c

infra_name: "coder-amanibhavam-school"
infra_vclusters: []

infra: {
	_base: {
		domain_zone: "defn.run"
		domain_name: "school.amanibhavam.defn.run"
		domain_slug: "school-amanibhavam-defn-run"

		secrets_region:   "us-west-2"
		issuer:           "zerossl-production"
		cloudflare_email: "cloudflare@defn.us"
	}

	"\(infra_name)": bootstrap: {
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
		"coder": [100, ""]
		"headlamp": [100, ""]
	}
}
