package dev

template: "service.yaml": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "nginx"
		namespace: "nginx"
	}
	spec: {
		selector: app: "nginx"
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 80
		}]
		type: "LoadBalancer"
	}
}
