package common

deploy: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		namespace: chart.name
		name:      "app"
		labels: app: "app"
	}
	spec: {
		replicas: 1
		selector: matchLabels: app: "app"
		template: {
			metadata: labels: app: "app"
			spec: containers: [{
				image: "app"
				name:  "cli"
				command: ["/api"]
				args: ["api"]
				ports: [{
					containerPort: 8080
				}]
			}]
		}
	}
}
