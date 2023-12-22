package y

res: service: "coder-amanibhavam-district-cluster-deathstar": default: deathstar: {
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
res: deployment: "coder-amanibhavam-district-cluster-deathstar": default: deathstar: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "deathstar"
		namespace: "default"
	}
	spec: {
		replicas: 3
		selector: matchLabels: {
			class: "deathstar"
			name:  "deathstar"
			org:   "empire"
		}
		template: {
			metadata: labels: {
				class: "deathstar"
				name:  "deathstar"
				org:   "empire"
			}
			spec: containers: [{
				image:           "docker.io/cilium/starwars:v1.0"
				imagePullPolicy: "IfNotPresent"
				name:            "deathstar"
			}]
		}
	}
}
res: ciliumnetworkpolicy: "coder-amanibhavam-district-cluster-deathstar": default: "deathstar-blueprints": {
	apiVersion: "cilium.io/v2"
	kind:       "CiliumNetworkPolicy"
	metadata: {
		name:      "deathstar-blueprints"
		namespace: "default"
	}
	spec: {
		endpointSelector: matchLabels: {
			class: "deathstar"
			org:   "empire"
		}
		ingress: [{
			fromEndpoints: [{
				matchLabels: org: "alliance"
			}]
			toPorts: [{
				ports: [{
					port:     "80"
					protocol: "TCP"
				}]
				rules: http: [{
					headers: ["X-Has-Force: True"]
					method: "PUT"
					path:   "/v1/exhaust-port$"
				}]
			}]
		}, {
			fromEndpoints: [{
				matchLabels: org: "empire"
			}]
			toPorts: [{
				ports: [{
					port:     "80"
					protocol: "TCP"
				}]
				rules: http: [{
					method: "GET"
					path:   "/v1/"
				}]
			}]
		}]
	}
}
