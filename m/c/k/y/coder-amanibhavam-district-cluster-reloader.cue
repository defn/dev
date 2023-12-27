package y

res: namespace: "coder-amanibhavam-district-cluster-reloader": cluster: reloader: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "reloader"
}
res: serviceaccount: "coder-amanibhavam-district-cluster-reloader": reloader: "reloader-reloader": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		annotations: {
			"meta.helm.sh/release-name":      "reloader"
			"meta.helm.sh/release-namespace": "reloader"
		}
		labels: {
			app:                            "reloader-reloader"
			"app.kubernetes.io/managed-by": "Helm"
			chart:                          "reloader-1.0.58"
			heritage:                       "Helm"
			release:                        "reloader"
		}
		name:      "reloader-reloader"
		namespace: "reloader"
	}
}
res: clusterrole: "coder-amanibhavam-district-cluster-reloader": cluster: "reloader-reloader-role": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		annotations: {
			"meta.helm.sh/release-name":      "reloader"
			"meta.helm.sh/release-namespace": "reloader"
		}
		labels: {
			app:                            "reloader-reloader"
			"app.kubernetes.io/managed-by": "Helm"
			chart:                          "reloader-1.0.58"
			heritage:                       "Helm"
			release:                        "reloader"
		}
		name: "reloader-reloader-role"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"secrets",
			"configmaps",
		]
		verbs: [
			"list",
			"get",
			"watch",
		]
	}, {
		apiGroups: ["apps"]
		resources: [
			"deployments",
			"daemonsets",
			"statefulsets",
		]
		verbs: [
			"list",
			"get",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["extensions"]
		resources: [
			"deployments",
			"daemonsets",
		]
		verbs: [
			"list",
			"get",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["batch"]
		resources: ["cronjobs"]
		verbs: [
			"list",
			"get",
		]
	}, {
		apiGroups: ["batch"]
		resources: ["jobs"]
		verbs: ["create"]
	}, {
		apiGroups: [""]
		resources: ["events"]
		verbs: [
			"create",
			"patch",
		]
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-reloader": cluster: "reloader-reloader-role-binding": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		annotations: {
			"meta.helm.sh/release-name":      "reloader"
			"meta.helm.sh/release-namespace": "reloader"
		}
		labels: {
			app:                            "reloader-reloader"
			"app.kubernetes.io/managed-by": "Helm"
			chart:                          "reloader-1.0.58"
			heritage:                       "Helm"
			release:                        "reloader"
		}
		name: "reloader-reloader-role-binding"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "reloader-reloader-role"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "reloader-reloader"
		namespace: "reloader"
	}]
}
res: deployment: "coder-amanibhavam-district-cluster-reloader": reloader: "reloader-reloader": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		annotations: {
			"meta.helm.sh/release-name":      "reloader"
			"meta.helm.sh/release-namespace": "reloader"
		}
		labels: {
			app:                            "reloader-reloader"
			"app.kubernetes.io/managed-by": "Helm"
			chart:                          "reloader-1.0.58"
			group:                          "com.stakater.platform"
			heritage:                       "Helm"
			provider:                       "stakater"
			release:                        "reloader"
			version:                        "v1.0.58"
		}
		name:      "reloader-reloader"
		namespace: "reloader"
	}
	spec: {
		replicas:             1
		revisionHistoryLimit: 2
		selector: matchLabels: {
			app:     "reloader-reloader"
			release: "reloader"
		}
		template: {
			metadata: labels: {
				app:                            "reloader-reloader"
				"app.kubernetes.io/managed-by": "Helm"
				chart:                          "reloader-1.0.58"
				group:                          "com.stakater.platform"
				heritage:                       "Helm"
				provider:                       "stakater"
				release:                        "reloader"
				version:                        "v1.0.58"
			}
			spec: {
				containers: [{
					image:           "ghcr.io/stakater/reloader:v1.0.58"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 5
						httpGet: {
							path: "/live"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					name: "reloader-reloader"
					ports: [{
						containerPort: 9090
						name:          "http"
					}]
					readinessProbe: {
						failureThreshold: 5
						httpGet: {
							path: "/metrics"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       10
						successThreshold:    1
						timeoutSeconds:      5
					}
					securityContext: {}
				}]
				securityContext: {
					runAsNonRoot: true
					runAsUser:    65534
				}
				serviceAccountName: "reloader-reloader"
			}
		}
	}
}
