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
			host: "www.district.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "nginx"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}, {
			host: "www.district.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "api"
					port: number: 80
				}
				path:     "/api"
				pathType: "Prefix"
			}]
		}]
	}
}
