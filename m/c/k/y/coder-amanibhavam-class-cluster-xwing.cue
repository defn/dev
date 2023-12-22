package y

res: service: "coder-amanibhavam-class-cluster-xwing": default: deathstar: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: "io.cilium/global-service": "true"
		name:      "deathstar"
		namespace: "default"
	}
	spec: {
		ports: [{
			port: 80
		}]
		selector: {
			class: "deathstar"
			org:   "empire"
		}
		type: "ClusterIP"
	}
}
res: deployment: "coder-amanibhavam-class-cluster-xwing": default: xwing: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "xwing"
		namespace: "default"
	}
	spec: {
		replicas: 3
		selector: matchLabels: {
			class: "spaceship"
			name:  "xwing"
			org:   "alliance"
		}
		template: {
			metadata: labels: {
				class: "spaceship"
				name:  "xwing"
				org:   "alliance"
			}
			spec: containers: [{
				image:           "docker.io/tgraf/netperf:v1.0"
				imagePullPolicy: "IfNotPresent"
				name:            "spaceship"
			}]
		}
	}
}
