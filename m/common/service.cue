package common

template: "service-app.yaml": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		namespace: chart.name
		name: "app"
	}
	spec: {
		selector: app: metadata.name
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 8080
		}]
	}
}
