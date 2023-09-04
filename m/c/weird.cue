package c

import (
	core "k8s.io/api/core/v1"
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

// https://artifacthub.io/packages/helm/argo/argo-workflows
kustomize: "argo-workflows": #KustomizeHelm & {
	helm: {
		release:   "argo-workflows"
		name:      "argo-workflows"
		namespace: "argo-workflows"
		version:   "0.33.1"
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
		version:   "15.1.5"
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
		version:   "0.3.2"
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

// https://artifacthub.io/packages/helm/backstage/backstage
kustomize: "backstage": #KustomizeHelm & {
	cluster: #Cluster

	namespace: "backstage"

	helm: {
		release:   "backstage"
		name:      "backstage"
		namespace: "backstage"
		version:   "1.2.0"
		repo:      "https://backstage.github.io/charts"
		values: {
			postgresql: enabled: true
		}
	}

	resource: "namespace-backstage": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "backstage"
		}
	}

	resource: "ingress-backstage": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "backstage"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "backstage.\(cluster.domain_name)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "backstage.\(cluster.domain_name)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "backstage"
						port: number: 7007
					}
				}]
			}]
		}
	}

	jsp: "deployment-backstage": {
		target: {
			kind:      "Deployment"
			name:      "backstage"
			namespace: "backstage"
		}
		patches: [{
			op:   "add"
			path: "/spec/template/spec/containers/0/env/-"
			value: {
				name:  "APP_CONFIG_app_baseUrl"
				value: "https://backstage.\(cluster.domain_name)"
			}
		}, {
			op:   "add"
			path: "/spec/template/spec/containers/0/env/-"
			value: {
				name:  "APP_CONFIG_backend_baseUrl"
				value: "https://backstage.\(cluster.domain_name)"
			}
		}, {
			op:   "add"
			path: "/spec/template/spec/containers/0/env/-"
			value: {
				name:  "APP_CONFIG_organization_name"
				value: cluster.domain_name
			}
		}]
	}
}

kustomize: "coredns": #Kustomize & {
	resource: "configmap-coredns": core.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name:      "coredns-custom"
		metadata: namespace: "kube-system"
		data: "ts.net.server": """
			  ts.net {
			    forward . 100.100.100.100
			   }
			"""
	}
}
