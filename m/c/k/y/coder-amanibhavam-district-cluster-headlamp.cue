package y

res: namespace: "coder-amanibhavam-district-cluster-headlamp": cluster: headlamp: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "headlamp"
}
res: serviceaccount: "coder-amanibhavam-district-cluster-headlamp": headlamp: headlamp: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "headlamp"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "headlamp"
			"app.kubernetes.io/version":    "0.21.0"
			"helm.sh/chart":                "headlamp-0.17.1"
		}
		name:      "headlamp"
		namespace: "headlamp"
	}
}
res: serviceaccount: "coder-amanibhavam-district-cluster-headlamp": headlamp: "headlamp-admin": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "headlamp-admin"
		namespace: "headlamp"
	}
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-headlamp": cluster: "headlamp-admin": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "headlamp"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "headlamp"
			"app.kubernetes.io/version":    "0.21.0"
			"helm.sh/chart":                "headlamp-0.17.1"
		}
		name: "headlamp-admin"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "headlamp"
		namespace: "headlamp"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-headlamp": cluster: "headlamp-admin-binding": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "headlamp-admin-binding"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "headlamp-admin"
		namespace: "headlamp"
	}]
}
res: secret: "coder-amanibhavam-district-cluster-headlamp": headlamp: oidc: {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "oidc"
		namespace: "headlamp"
	}
	type: "Opaque"
}
res: service: "coder-amanibhavam-district-cluster-headlamp": headlamp: headlamp: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "headlamp"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "headlamp"
			"app.kubernetes.io/version":    "0.21.0"
			"helm.sh/chart":                "headlamp-0.17.1"
		}
		name:      "headlamp"
		namespace: "headlamp"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			protocol:   "TCP"
			targetPort: "http"
		}]
		selector: {
			"app.kubernetes.io/instance": "headlamp"
			"app.kubernetes.io/name":     "headlamp"
		}
		type: "ClusterIP"
	}
}
res: deployment: "coder-amanibhavam-district-cluster-headlamp": headlamp: headlamp: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "headlamp"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "headlamp"
			"app.kubernetes.io/version":    "0.21.0"
			"helm.sh/chart":                "headlamp-0.17.1"
		}
		name:      "headlamp"
		namespace: "headlamp"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/instance": "headlamp"
			"app.kubernetes.io/name":     "headlamp"
		}
		template: {
			metadata: labels: {
				"app.kubernetes.io/instance": "headlamp"
				"app.kubernetes.io/name":     "headlamp"
			}
			spec: {
				containers: [{
					args: [
						"-in-cluster",
						"-plugins-dir=/headlamp/plugins",
					]
					image:           "ghcr.io/headlamp-k8s/headlamp:v0.21.0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: httpGet: {
						path: "/"
						port: "http"
					}
					name: "headlamp"
					ports: [{
						containerPort: 4466
						name:          "http"
						protocol:      "TCP"
					}]
					readinessProbe: httpGet: {
						path: "/"
						port: "http"
					}
					resources: {}
					securityContext: {
						privileged:   false
						runAsGroup:   101
						runAsNonRoot: true
						runAsUser:    100
					}
				}]
				securityContext: {}
				serviceAccountName: "headlamp"
			}
		}
	}
}
res: ingress: "coder-amanibhavam-district-cluster-headlamp": headlamp: headlamp: {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			"traefik.ingress.kubernetes.io/router.tls":         "true"
		}
		name:      "headlamp"
		namespace: "headlamp"
	}
	spec: {
		ingressClassName: "traefik"
		rules: [{
			host: "headlamp.district.amanibhavam.defn.run"
			http: paths: [{
				backend: service: {
					name: "headlamp"
					port: number: 80
				}
				path:     "/"
				pathType: "Prefix"
			}]
		}]
	}
}
