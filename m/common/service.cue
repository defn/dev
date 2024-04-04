package common

template: "service-app.yaml": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "app"
	}
	spec: {
		selector: app: "app"
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 8080
		}]
	}
}
