@experiment(aliasv2)
@experiment(explicitopen)

package common

template: "deployment-app.yaml": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		namespace: chart.name
		labels: app: name
		name: "app"
	}
	spec: {
		replicas: 3
		selector: matchLabels: app: metadata.name
		template: {
			"metadata": labels: app: metadata.name
			spec: containers: [{
				name:  metadata.name
				image: "app"
				ports: [{
					containerPort: 80
				}]
			}]
		}
	}
}
