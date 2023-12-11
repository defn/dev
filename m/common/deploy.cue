package common

deploy: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "app"
		namespace: chart.name
		labels: app: "app"
	}
	spec: {
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
