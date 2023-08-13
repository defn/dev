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

			// network
			"cilium": [4, ""]

			// aws
			"pod-identity": [5, ""]

			// secrets
			"external-secrets": [10, ""]
			"ubuntu": [10, ""]

			// secrets
			"secrets": [20, ""]

			// shared, external
			"shared": [30, ""]
			"external-dns": [30, ""]
			"tailscale": [30, ""]

			// functions
			"knative": [40, ""]
			"kourier": [40, ""]

			// ingress
			"traefik": [50, ""]

			// argocd
			"argo-cd": [9, ""]

			// vcluster
			"\(cluster_type)-\(cluster_name)-vc0": [8, ""]
			"\(cluster_type)-\(cluster_name)-vc1": [8, ""]

			// vcluster workloads
			"vcluster-\(cluster_type)-\(cluster_name)-vc0": [9, ""]
			"vcluster-\(cluster_type)-\(cluster_name)-vc1": [9, ""]
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

kustomize: "shared": #Kustomize & {
	resource: "externalsecret-\(_issuer)": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      _issuer
			namespace: "cert-manager"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster_type)-\(cluster_name)"
			}]
			target: {
				name:           _issuer
				creationPolicy: "Owner"
			}
		}
	}

	resource: "externalsecret-external-dns": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "external-dns"
			namespace: "external-dns"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: cluster_name
			}
			dataFrom: [{
				extract: key: "\(cluster_type)-\(cluster_name)"
			}]
			target: {
				name:           "external-dns"
				creationPolicy: "Owner"
			}
		}
	}

	resource: "clusterpolicy-clusterissuer-\(_issuer)": {
		apiVersion: "kyverno.io/v1"
		kind:       "ClusterPolicy"
		metadata: name: "\(_issuer)-clusterissuer"
		spec: {
			generateExistingOnPolicyUpdate: true
			rules: [{
				name: "create-cluster-issuer"
				match: any: [{
					resources: {
						names: [
							_issuer,
						]
						kinds: [
							"Secret",
						]
						namespaces: [
							"cert-manager",
						]
					}
				}]
				generate: {
					synchronize: true
					apiVersion:  "cert-manager.io/v1"
					kind:        "ClusterIssuer"
					name:        _issuer
					data: spec: acme: {
						server: "https://acme.zerossl.com/v2/DV90"
						email:  "{{request.object.data.zerossl_email | base64_decode(@)}}"

						privateKeySecretRef: name: "\(_issuer)-acme"

						externalAccountBinding: {
							keyID: "{{request.object.data.zerossl_eab_kid | base64_decode(@)}}"
							keySecretRef: {
								name: _issuer
								key:  "zerossl_eab_hmac"
							}
						}

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: _issuer
									key:  "cloudflare_api_token"
								}
							}
						}]
					}
				}
			}]
		}
	}
}
