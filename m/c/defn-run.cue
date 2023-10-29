package c

import (
	"strings"
)

teacher: {
	bootstrap: {
		// essentials
		"kyverno": [100, "", "ServerSideApply=true"]
		"cert-manager": [100, ""]
		"trust-manager": [100, ""]

		// external secrets
		"pod-identity": [100, ""]
		"external-secrets": [100, ""]
		"secrets": [100, ""]

		// tailscale
		//"tailscale": [100, ""]

		// scaling
		"karpenter": [100, ""]

		// external dns, certs issuer
		"external-dns": [100, ""]
		"issuer": [100, ""]

		// traefik, functions
		"knative": [100, ""]
		"kourier": [100, ""]
		"traefik": [100, ""]
	}
}

class: {
	handle: string
	env:    string

	cluster_name: "coder-\(handle)-\(env)"
	name_suffix:  "."

	domain_zone: "defn.run"
	domain_name: "\(env).\(handle).\(domain_zone)"
	domain_slug: "\(env)-\(handle)-\(strings.Replace(domain_zone, ".", "-", -1))"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	cloudflare_email: "cloudflare@defn.us"

	discovery_url: "https://\(cluster_name).\(infra_tailscale_domain)"
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
	infra_k3s_version:      "rancher/k3s:v1.27.5-k3s1"
	infra_tailscale_domain: "tail3884f.ts.net"

	infra_cilium_name: cluster_name

	bootstrap: teacher.bootstrap
}

kustomize: "hello": #Kustomize & {
	#app_ns: "default"
	#funcs: ["hello", "bye"]

	cluster: #Cluster

	resource: "ingressroute-\(cluster.domain_name)": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      cluster.domain_name
			namespace: #app_ns
		}
		spec: entryPoints: ["websecure"]
		spec: routes: [{
			match: "HostRegexp(`{subdomain:[a-z0-9-]+}.default.\(cluster.domain_name)`)"
			kind:  "Rule"
			services: [{
				name:      "kourier-internal"
				namespace: "kourier-system"
				kind:      "Service"
				port:      80
				scheme:    "http"
			}]
		}]
	}

	for f in #funcs {
		resource: "kservice-\(f)": {
			apiVersion: "serving.knative.dev/v1"
			kind:       "Service"
			metadata: {
				//labels: "networking.knative.dev/visibility": "cluster-local"
				name:      f
				namespace: #app_ns
			}
			spec: {
				template: spec: {
					containerConcurrency: 0
					containers: [{
						name:  "whoami"
						image: "containous/whoami:latest"
						ports: [{
							containerPort: 80
						}]
					}]
				}
				traffic: [{
					latestRevision: true
					percent:        100
				}]
			}
		}
	}
}
