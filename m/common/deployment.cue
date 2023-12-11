package common

template: "deployment.yaml": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name: "www"
	}
	spec: {
		replicas: 3
		selector: matchLabels: app: "www"
		template: {
			metadata: labels: app: "www"
			spec: containers: [{
				name:  "www"
				image: "nginx:latest"
				ports: [{
					containerPort: 80
				}]
			}]
		}
	}
}
