package c

cluster_name: "dfd"
cluster_type: "k3d"
vclusters: [0, 1]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)-bootstrap": bootstrap: "cilium-bootstrap": [1, ""]
}).outputs

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)": {
		bootstrap: {
			// essentials
			"coredns": [2, ""]
			"kyverno": [2, "", "ServerSideApply=true"]
			"cert-manager-crds": [2, ""]

			// certificates
			"cert-manager": [3, ""]

			// network
			"cilium": [4, ""]

			// secrets, vpn
			"tailscale": [5, ""]
			"pod-identity": [5, ""]
			"external-secrets": [5, ""]

			// secrets
			"secrets": [20, ""]

			// shared, external
			"shared": [30, ""]
			"external-dns": [30, ""]

			// functions
			"knative": [40, ""]
			"kourier": [40, ""]

			// ingress
			"traefik": [50, ""]
			"argo-cd": [50, ""]

			// vclluster
			"\(cluster_type)-\(cluster_name)-vc0": [100, ""]
			"\(cluster_type)-\(cluster_name)-vc1": [100, ""]

			// vcluster workloads
			"vcluster-\(cluster_type)-\(cluster_name)-vc0": [200, ""]
			"vcluster-\(cluster_type)-\(cluster_name)-vc1": [200, ""]
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
		metadata: name: "dev"
		spec: provider: {
			// TODO replace with AWS secrets manager
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
				name: "dev"
			}
			dataFrom: [{
				extract: key: "dev/amanibhavam-global"
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
				name: "dev"
			}
			dataFrom: [{
				extract: key: "dev/amanibhavam-global"
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
								key:  "zerossl-eab-hmac"
							}
						}

						solvers: [{
							selector: {}
							dns01: cloudflare: {
								email: "{{request.object.data.cloudflare_email | base64_decode(@)}}"
								apiTokenSecretRef: {
									name: _issuer
									key:  "cloudflare-api-token"
								}
							}
						}]
					}
				}
			}]
		}
	}

	resource: "cluster-role-binding-admin": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "default-admin"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "cluster-admin"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "default"
			namespace: "default"
		}]
	}
}
