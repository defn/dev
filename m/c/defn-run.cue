package c

import (
	"strings"
)

k3s_bootstrap: {
	// secrets
	"cert-manager": {}
	"trust-manager": {}
	"pod-identity": {}
	"external-secrets": {}

	// config
	"coredns": {}
	"secrets": {}
	"issuer": {}

	// management
	"crossplane": {}
	"crossprovider": {}
	"karpenter": {}
	"cilium": {}
	"tailscale": {}
	"tetragon": {}
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}

	// traffic
	//"l5d-crds": {}
	//"l5d-control": {}

	// deploy
	"argo-cd": {}
}

infra: {
	[NAME=string]: class

	"\(class.cluster_name)-cluster": {}
}

teacher: {
	bootstrap: {
		[NAME=string]: {
			app_repo: "coder-amanibhavam-district.tail3884f.ts.net:5000"
			app_type: "chart"
			app_def:  "library/helm/coder-\(class.handle)-\(class.env)-cluster-\(NAME)"
		}
	}
}

class: #Cluster & {
	handle:     string
	env:        string
	parent_env: string

	cluster_name: "coder-\(handle)-\(env)"
	name_suffix:  "."

	domain_zone: "defn.run"
	domain_name: "\(parent_env).\(handle).\(domain_zone)"
	domain_slug: "\(parent_env)-\(handle)-\(strings.Replace(domain_zone, ".", "-", -1))"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	#issuer:          "letsencrypt-production"
	cloudflare_email: "cloudflare@defn.us"

	discovery_url: string | *"TODO:"
	discovery: {
		issuer:                 discovery_url
		jwks_uri:               "\(discovery_url)/openid/.well-known/jwks.json"
		authorization_endpoint: "urn:kubernetes:programmatic_authorization"
		response_types_supported: [
			"id_token",
		]
		subject_types_supported: [
			"public",
		]
		id_token_signing_alg_values_supported: [
			"RS256",
		]
		claims_supported: [
			"sub",
			"iss",
		]
	}

	infra_account_id:       "510430971399"
	infra_k3s_version:      "rancher/k3s:v1.27.10-k3s2"
	infra_tailscale_domain: "tail3884f.ts.net"

	infra_cilium_name: cluster_name

	bootstrap: teacher.bootstrap
}
