package c

cluster_type: "k3d"
cluster_name: "dfd"
vclusters: [0, 1]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)-bootstrap": bootstrap: {
		"cilium-bootstrap": [1, ""]
		"cert-manager-crds": [1, ""]
	}
}).outputs

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)": {
		bootstrap: {
			// essentials
			"coredns": [2, ""]
			"kyverno": [2, "", "ServerSideApply=true"]
			"cert-manager": [2, ""]

			// aws irsa
			"pod-identity": [2, ""]

			// external secrets
			"external-secrets": [10, ""]

			// secrets store
			"secrets": [20, ""]

			// external dns, vpn, issuer
			"external-dns": [30, ""]
			"tailscale": [30, ""]
			"issuer": [30, ""]

			// traefik, functions
			"knative": [40, ""]
			"kourier": [40, ""]
			"traefik": [40, ""]

			// endgame
			"cilium": [60, ""]
			"argo-cd": [60, ""]
			"ubuntu": [60, ""]
			"hello": [60, ""]

			// experimental
			"backstage": [100, ""]

			for v in vclusters {
				// vcluster
				"\(cluster_type)-\(cluster_name)-vc\(v)": [100, ""]

				// vcluster workloads
				"vcluster-\(cluster_type)-\(cluster_name)-vc\(v)": [101, ""]
			}
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		[string]: {
			instance_types: []
			parent: env[cluster_name]
		}
		"\(cluster_type)-\(cluster_name)-vc0": {
			bootstrap: {
				"kyverno": [3, "", "ServerSideApply=true"]
			}
		}
		"\(cluster_type)-\(cluster_name)-vc1": {
			bootstrap: {
				"kyverno": [3, "", "ServerSideApply=true"]
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		[string]: vc_machine: cluster_name
		for v in vclusters {
			"\(cluster_type)-\(cluster_name)-vc\(v)": vc_index: v
		}
	}
}).outputs

kustomize: "secrets": #Kustomize & {
	resource: "cluster-secret-store": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ClusterSecretStore"
		metadata: name: cluster_name
		spec: provider: aws: {
			service: "SecretsManager"
			region:  "us-west-2"
		}
	}
}

kustomize: "hello": #Kustomize & {
	namespace: "default"

	_funcs: ["hello", "bye"]
	_domain: "default.defn.run"

	resource: "ingressroute-\(_domain)": {
		apiVersion: "traefik.containo.us/v1alpha1"
		kind:       "IngressRoute"
		metadata: {
			name:      _domain
			namespace: "default"
		}
		spec: entryPoints: ["websecure"]
		spec: routes: [{
			match: "HostRegexp(`{subdomain:[a-z0-9-]+}.\(_domain)`)"
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
				namespace: "default"
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
