package common

template: "ingress.yaml": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			"traefik.ingress.kubernetes.io/router.tls":         "true"
		}
		name: "nginx"
	}
	spec: {
		ingressClassName: "traefik"
		rules: [{
			host: value.host
			http: paths: [{
				backend: service: {
					name: "www"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}, {
			host: value.host
			http: paths: [{
				backend: service: {
					name: "app"
					port: number: 80
				}
				path:     "/api"
				pathType: "Prefix"
			}]
		}]
	}
}
