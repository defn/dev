package k3d

kube: headlamp: Service: headlamp: {
	kind:       "Service"
	apiVersion: "v1"
	metadata: {
		name:      "headlamp"
		namespace: "kube-system"
	}
	spec: {
		ports: [{
			port:       80
			targetPort: 4466
		}]
		selector: "k8s-app": "headlamp"
	}
}
kube: headlamp: Deployment: headlamp: {
	kind:       "Deployment"
	apiVersion: "apps/v1"
	metadata: {
		name:      "headlamp"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "k8s-app": "headlamp"
		template: {
			metadata: labels: "k8s-app": "headlamp"
			spec: {
				containers: [{
					name:  "headlamp"
					image: "ghcr.io/headlamp-k8s/headlamp:latest"
					args: [
						"-in-cluster",
						"-plugins-dir=/headlamp/plugins",
					]
					ports: [{containerPort: 4466}]
					readinessProbe: {
						httpGet: {
							scheme: "HTTP"
							path:   "/"
							port:   4466
						}
						initialDelaySeconds: 30
						timeoutSeconds:      30
					}
					livenessProbe: {
						httpGet: {
							scheme: "HTTP"
							path:   "/"
							port:   4466
						}
						initialDelaySeconds: 30
						timeoutSeconds:      30
					}
				}]
				nodeSelector: "kubernetes.io/os": "linux"
			}
		}
	}
}
kube: headlamp: Secret: "headlamp-admin": {
	kind:       "Secret"
	apiVersion: "v1"
	metadata: {
		name:      "headlamp-admin"
		namespace: "kube-system"
		annotations: "kubernetes.io/service-account.name": "headlamp-admin"
	}
	type: "kubernetes.io/service-account-token"
}
