package c

import (
	"strings"
)

infra_name: "dfd"

infra: {
	[NAME=string]: _base & {
		if strings.HasPrefix(NAME, "vc") {
			cluster_name: "\(parent.cluster_name)-\(NAME)"
			name_suffix:  "-\(NAME)."
		}
	}

	_base: {
		domain_zone: "defn.run"
		domain_name: "dev.amanibhavam.defn.run"
		domain_slug: "dev-amanibhavam-defn-run"

		secrets_region:   "us-west-2"
		issuer:           "zerossl-production"
		cloudflare_email: "cloudflare@defn.us"
	}

	parent: {
		cluster_name: "k3d-\(infra_name)"
		vclusters: ["vc0", "vc1"]
	}

	"\(infra_name)":                  parent
	"\(parent.cluster_name)-cluster": parent

	manual:                          parent
	"\(parent.cluster_name)-manual": manual

	for i, v in parent.vclusters {
		"\(v)": {}
		"\(infra[v].cluster_name)": infra[v]
	}
}

cluster_bootstrap: {
	// ~~~~~ Wave 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// essentials
	"kyverno": [2, "", "ServerSideApply=true"]
	"cert-manager": [2, ""]

	// ~~~~~ Wave 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// external secrets
	"pod-identity": [10, ""]
	"external-secrets": [11, ""]
	"secrets": [12, ""]

	// ~~~~~ Wave 30 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// external dns, issuer
	"external-dns": [30, ""]
	"issuer": [30, ""]

	// ~~~~~ Wave 40 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// traefik, functions
	"knative": [40, ""]
	"kourier": [40, ""]
	"traefik": [40, ""]

	// ~~~~~ Wave 100+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// applications
	"hello": [100, ""]
}

vcluster_bootstrap: {
	// ~~~~~ Wave 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// essentials
	"kyverno": [2, "", "ServerSideApply=true"]

	// ~~~~~ Wave 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// external secrets
	"pod-identity": [10, ""]

	// ~~~~~ Wave 100+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//
	// applications
	"emojivoto": [100, "", "ServerSideApply=true"]
}

kustomize: "hello": #Kustomize & {
	_app_ns: "default"
	_funcs: ["hello", "bye"]

	cluster: #Cluster

	resource: "ingressroute-\(cluster.domain_name)": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      cluster.domain_name
			namespace: _app_ns
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

	for f in _funcs {
		resource: "kservice-\(f)": {
			apiVersion: "serving.knative.dev/v1"
			kind:       "Service"
			metadata: {
				//labels: "networking.knative.dev/visibility": "cluster-local"
				name:      f
				namespace: _app_ns
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
