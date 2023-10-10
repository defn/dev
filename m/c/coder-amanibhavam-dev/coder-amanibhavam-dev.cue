package c

teacher_handle: "amanibhavam"
teacher_env: "dev"
infra_name:     "k3d-dfd"
infra_alt_name: "coder-\(teacher_handle)-\(teacher_env)"

infra: {
	"\(infra_name)": cluster_alt_name: infra_alt_name

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
		"headlamp": [100, ""]
		"postgres-operator": [100, ""]
		"coder": [100, ""]
		"hello": [100, ""]
		"pihole": [100, ""]
		"dex": [100, ""]
		"mastodon": [100, ""]
	}

	vc0: vcluster: k3s_version: "rancher/k3s:v1.27.5-k3s1"
	vc0: bootstrap: {
		"emojivoto": [100, ""]
	}

	vc1: vcluster: k3s_version: vc0.vcluster.k3s_version
	vc1: bootstrap: vc0.bootstrap
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

kustomize: "bonchon": #Kustomize & {
	for chicken in ["rocky", "rosie"] {
		resource: "pre-sync-hook-dry-brine-\(chicken)-chicken": {
			apiVersion: "batch/v1"
			kind:       "Job"
			metadata: {
				name:      "dry-brine-\(chicken)-chicken"
				namespace: "default"
				annotations: "argocd.argoproj.io/hook": "PreSync"
			}

			spec: backoffLimit: 0
			spec: template: spec: {
				serviceAccountName: "default"
				containers: [{
					name:  "meh"
					image: "defn/dev:kubectl"
					command: ["bash", "-c"]
					args: ["""
                    test "completed" == "$(kubectl get tf "\(chicken)" -o json | jq -r '.status.phase')"
                    """]
				}]
				restartPolicy: "Never"
			}
		}
	}

	resource: "tfo-demo-bonchon": {
		apiVersion: "tf.isaaguilar.com/v1alpha2"
		kind:       "Terraform"

		metadata: {
			name:      "bonchon"
			namespace: "default"
		}

		spec: {
			terraformVersion: "1.0.0"
			terraformModule: source: "https://github.com/defn/dev/m.git//tf/fried-chicken?ref=main"

			serviceAccount: "default"
			scmAuthMethods: []

			ignoreDelete:       true
			keepLatestPodsOnly: true

			outputsToOmit: ["0"]

			backend: """
				terraform {
				    backend "kubernetes" {
				        in_cluster_config = true
				        secret_suffix     = "bonchon"
				        namespace         = "default"
				    }
				}
				"""
		}
	}
}
