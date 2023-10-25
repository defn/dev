package c

import (
	core "k8s.io/api/core/v1"
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

// https://artifacthub.io/packages/helm/kedacore/keda
kustomize: "keda": #KustomizeHelm & {
	namespace: "keda"

	helm: {
		release: "keda"
		name:    "keda"
		version: "2.12.0"
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

// https://artifacthub.io/packages/helm/bitnami/nginx
kustomize: "nginx": #KustomizeHelm & {
	namespace: "nginx"

	helm: {
		release:   "nginx"
		name:      "nginx"
		namespace: "nginx"
		version:   "15.3.1"
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
