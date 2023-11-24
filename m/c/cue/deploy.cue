package dev

deploy: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "api"
		namespace: "dev"
		labels: app: "api"
	}
	spec: {
		selector: matchLabels: app: "api"
		template: {
			metadata: labels: app: "api"
			spec: containers: [{
				image: "api"
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
