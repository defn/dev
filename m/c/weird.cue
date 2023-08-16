package c

import (
	core "k8s.io/api/core/v1"
	batch "k8s.io/api/batch/v1"
	apps "k8s.io/api/apps/v1"
	rbac "k8s.io/api/rbac/v1"
)

kustomize: (#Transform & {
	transformer: #TransformChicken

	inputs: {
		rocky: {}
		rosie: {}
	}
}).outputs

//kustomize: "events": #Kustomize & {
//	namespace: "default"
//
//	resource: "events": {
//		url: "events.yaml"
//	}
//}
//
//kustomize: "demo1": #Kustomize & {
//	resource: "demo": {
//		url: "https://bit.ly/demokuma"
//	}
//}
//
//kustomize: "demo2": #Kustomize & {
//	resource: "demo": {
//		url: "https://raw.githubusercontent.com/kumahq/kuma-counter-demo/master/demo.yaml"
//	}
//}

kustomize: "argo-events": #KustomizeHelm & {
	namespace: "argo-events"

	helm: {
		release: "argo-events"
		name:    "argo-events"
		version: "2.0.6"
		repo:    "https://argoproj.github.io/argo-helm"
	}

	resource: "namespace-argo-events": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argo-events"
		}
	}
}

// https://artifacthub.io/packages/helm/coder-v2/coder
kustomize: "coder": #KustomizeHelm & {
	namespace: "coder"

	_host: "coder.defn.run"

	helm: {
		release:   "coder"
		name:      "coder"
		namespace: "coder"
		version:   "2.0.2"
		repo:      "https://helm.coder.com/v2"
		values: {
			coder: {
				service: type: "ClusterIP"

				env: [{
					name: "CODER_ACCESS_URL"
					valueFrom: secretKeyRef: {
						name: "coder"
						key:  "CODER_ACCESS_URL"
					}
				}]
			}
		}
	}

	resource: "namespace-coder": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "coder"
		}
	}

	resource: "ingress-coder": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "coder"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        _host
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: _host
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "coder"
						port: number: 80
					}
				}]
			}]
		}
	}

	resource: "externalsecret-coder": {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      "coder"
			namespace: "coder"
		}
		spec: {
			refreshInterval: "1h"
			secretStoreRef: {
				kind: "ClusterSecretStore"
				name: "dev"
			}
			dataFrom: [{
				extract: key: "dev/amanibhavam-global-coder"
			}]
			target: {
				name:           "coder"
				creationPolicy: "Owner"
			}
		}
	}

}

// https://artifacthub.io/packages/helm/argo/argo-workflows
kustomize: "argo-workflows": #KustomizeHelm & {
	helm: {
		release:   "argo-workflows"
		name:      "argo-workflows"
		namespace: "argo-workflows"
		version:   "0.32.2"
		repo:      "https://argoproj.github.io/argo-helm"
		values: {
			controller: workflowNamespaces: [
				"argo-workflows",
				"defn",
			]
		}
	}

	resource: "namespace-argo-workflows": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "argo-workflows"
		}
	}
}

// https://artifacthub.io/packages/helm/kedacore/keda
kustomize: "keda": #KustomizeHelm & {
	namespace: "keda"

	helm: {
		release: "keda"
		name:    "keda"
		version: "2.11.2"
		repo:    "https://kedacore.github.io/charts"
	}

	resource: "namespace-keda": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "keda"
		}
	}
}

kustomize: "dev": #Kustomize & {
	namespace: "default"

	resource: "statefulset-dev": apps.#StatefulSet & {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
		metadata: {
			name:      "dev"
			namespace: "default"
		}
		spec: {
			serviceName: "dev"
			replicas:    1
			selector: matchLabels: app: "dev"
			template: {
				metadata: labels: app: "dev"
				spec: {
					volumes: [{
						name: "work"
						emptyDir: {}
					}]
					containers: [{
						name:            "code-server"
						image:           "169.254.32.1:5000/workspace"
						imagePullPolicy: "Always"
						command: [
							"/usr/bin/tini",
							"--",
						]
						args: [
							"bash",
							"-c",
							"exec ~/bin/e code-server --bind-addr 0.0.0.0:8888 --disable-telemetry",
						]
						tty: true
						env: [{
							name:  "PASSWORD"
							value: "admin"
						}]
						securityContext: privileged: true
						volumeMounts: [{
							mountPath: "/work"
							name:      "work"
						}]
					}]
				}
			}
		}
	}

	resource: "service-dev": core.#Service & {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name:      "dev"
			namespace: "default"
		}
		spec: {
			ports: [{
				port:       80
				protocol:   "TCP"
				targetPort: 8888
			}]
			selector: app: "dev"
			type: "ClusterIP"
		}
	}

	resource: "cluster-role-binding-admin": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "dev-admin"
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

	resource: "cluster-role-binding-delegator": rbac.#ClusterRoleBinding & {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "dev-delegator"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "system:auth-delegator"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "default"
			namespace: "default"
		}]
	}
}

// gen_karpenter.sh
kustomize: "karpenter": #Kustomize & {
	namespace: "karpenter"

	resource: "karpenter": {
		url: "karpenter.yaml"
	}

	resource: "namespace-karpenter": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "karpenter"
		}
	}

	resource: (#Transform & {
		transformer: #TransformKarpenterProvisioner

		inputs: {
			for _env_name, _env in env {
				if (_env & #VCluster) != _|_ {
					if len(_env.instance_types) > 0 {
						"\(_env_name)": {}
					}
				}
			}

			[N=string]: {
				label:          "provisioner-\(N)"
				instance_types: env[N].instance_types
			}
		}
	}).outputs
}

// https://artifacthub.io/packages/helm/bitnami/nginx
kustomize: "nginx": #KustomizeHelm & {
	namespace: "nginx"

	helm: {
		release:   "nginx"
		name:      "nginx"
		namespace: "nginx"
		version:   "15.1.3"
		repo:      "https://charts.bitnami.com/bitnami"
		values: {
		}
	}

	resource: "namespace-nginx": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "nginx"
		}
	}

	psm: "service-nginx": {
		apiVersion: "v1"
		kind:       "Service"

		metadata: {
			name:      "nginx"
			namespace: "nginx"
		}

		spec: {
			type: "ClusterIP"
		}
	}
}

// https://artifacthub.io/packages/helm/alekc/caddy
kustomize: "caddy": #KustomizeHelm & {
	namespace: "caddy"

	helm: {
		release:   "caddy"
		name:      "caddy"
		namespace: "caddy"
		version:   "0.2.4"
		repo:      "https://charts.alekc.dev"
		values: {
			listenPort: 80
			https: {
				enabled: true
				port:    443
			}
			config: global: """
				auto_https disable_certs

				local_certs

				log {
				    output stdout
				}
				"""

			config: caddyFile: """
				https://*.defn.run {
				    tls /certs/tls.crt /certs/tls.key
				    reverse_proxy {http.request.host.labels.2}.default.svc.cluster.local:80 {
				        header_up -Host
				        header_up X-defn-label0	"{http.request.host.labels.0}"
				        header_up X-defn-label1	"{http.request.host.labels.1}"
				        header_up X-defn-label2	"{http.request.host.labels.2}"
				    }
				}
				"""

			volumes: [{
				name: "certs"
				secret: {
					secretName: "defn-run-wildcard"
					optional:   false
				}
			}]

			volumeMounts: [{
				name:      "certs"
				mountPath: "/certs"
			}]
		}
	}

	resource: "namespace-caddy": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "caddy"
		}
	}

	psm: "service-tailscale": {
		apiVersion: "v1"
		kind:       "Service"

		metadata: {
			name: "caddy"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname": "caddy.defn.run"
			}
		}

		spec: {
			type:              "LoadBalancer"
			loadBalancerClass: "tailscale"
		}
	}
}

// https://github.com/isaaguilar/terraform-operator/releases
kustomize: "tfo": #Kustomize & {
	namespace: "tf-system"

	resource: "tfo": {
		url: "https://raw.githubusercontent.com/GalleyBytes/terraform-operator/v0.12.1/deploy/bundles/v0.12.0/v0.12.0.yaml"
	}
}

kustomize: "bonchon": #Kustomize & {
	for chicken in ["rocky", "rosie"] {
		resource: "pre-sync-hook-dry-brine-\(chicken)-chicken": batch.#Job & {
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

kustomize: "defn": #Kustomize & {
	resource: "namespace-defn": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "defn"
		}
	}

	resource: "workflow-hello": {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Workflow"
		metadata: {
			name:      "hello"
			namespace: "defn"
		}
		spec: {
			entrypoint: "whalesay"
			arguments: parameters: [{
				name:  "message"
				value: "world"
			}]
			templates: [{
				name: "whalesay"
				inputs: parameters: [{
					name: "message"
				}]
				container: {
					image: "docker/whalesay"
					command: ["cowsay"]
					args: ["{{inputs.parameters.message}}"]
				}
			}]
		}
	}
}
