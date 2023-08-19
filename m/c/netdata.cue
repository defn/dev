package c

import (
	core "k8s.io/api/core/v1"
)

// https://artifacthub.io/packages/helm/netdata/netdata
kustomize: "netdata": #KustomizeHelm & {
	namespace: "netdata"

	helm: {
		release: "netdata"
		name:    "netdata"
		version: "3.7.68"
		repo:    "https://netdata.github.io/helmchart"
		values: {
			ingress: enabled: false
		}
	}

	resource: "namespace-netdata": core.#Namespace & {
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: {
			name: "netdata"
		}
	}

	resource: "ingress-netdata": {
		apiVersion: "networking.k8s.io/v1"
		kind:       "Ingress"
		metadata: {
			name: "netdata"
			annotations: {
				"external-dns.alpha.kubernetes.io/hostname":        "netdata.\(_domain)"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			}
		}

		spec: {
			ingressClassName: "traefik"
			rules: [{
				host: "netdata.\(_domain)"
				http: paths: [{
					path:     "/"
					pathType: "Prefix"
					backend: service: {
						name: "netdata"
						port: number: 19999
					}
				}]
			}]
		}
	}
}
