package c

import (
	"strings"
)

infra: {
	[NAME=string]: _base & {
		if strings.HasPrefix(NAME, "vc") {
			cluster_name: "\(parent.cluster_name)-\(NAME)"
			name_suffix:  "-\(NAME)"
		}
	}

	_base: {
		domain_zone: "defn.run"
		domain_name: "dev.amanibhavam.defn.run"
		domain_slug: "dev-amanibhavam-defn-run"

		issuer:           "zerossl-production"
		cloudflare_email: "cloudflare@defn.us"
	}

	parent: {
		cluster_name: "k3d-dfd"
		vclusters: [0, 1]
	}

	dfd: parent
	vc0: {}
	vc1: {}
}

kustomize: [string]: cluster: infra.dfd

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(infra.dfd.cluster_name)-manual": {
		bootstrap: {
			"cilium-bootstrap": [1, ""]
			"cert-manager-crds": [1, ""]
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(infra.dfd.cluster_name)-cluster": {
		bootstrap: {
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
			// bootstrapped
			"cilium": [100, ""]
			"argo-cd": [100, ""]

			// cluster.vclusters
			for v in infra.dfd.vclusters {
				// vcluster
				"\(infra.dfd.cluster_name)-vc\(v)-vcluster": [100, ""]

				// vcluster workload
				"\(infra["vc\(v)"].cluster_name)-env": [101, ""]
			}

			// experimental
			"hello": [100, ""]
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		for v in infra.dfd.vclusters {
			"\(infra["vc\(v)"].cluster_name)": {
				instance_types: []
				parent: env["\(infra.dfd.cluster_name)-cluster"]
				bootstrap: {
					"kyverno": [2, "", "ServerSideApply=true"]
					"cert-manager": [2, ""]
					"pod-identity": [10, ""]
					"emojivoto": [100, "", "ServerSideApply=true"]
				}
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		for v in infra.dfd.vclusters {
			"\(infra["vc\(v)"].cluster_name)-vcluster": {
				vc_index:   v
				vc_machine: infra["vc\(v)"].cluster_name
			}
		}
	}
}).outputs

kustomize: "secrets": #Kustomize & {
	cluster: #Cluster

	resource: "cluster-secret-store": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ClusterSecretStore"
		metadata: name: cluster.cluster_name
		spec: provider: aws: {
			service: "SecretsManager"
			region:  "us-west-2"
		}
	}
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
