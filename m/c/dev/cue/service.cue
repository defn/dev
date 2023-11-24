package dev

template: "service-www.yaml": {
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
	}
}

template: "service-api.yaml": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "api"
		namespace: "nginx"
	}
	spec: {
		selector: app: "api"
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 8080
		}]
	}
}
