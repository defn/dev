package y

res: namespace: "coder-amanibhavam-district-cluster-descheduler": cluster: descheduler: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "descheduler"
}
res: serviceaccount: "coder-amanibhavam-district-cluster-descheduler": descheduler: descheduler: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "descheduler"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "descheduler"
			"app.kubernetes.io/version":    "0.29.0"
			"helm.sh/chart":                "descheduler-0.29.0"
		}
		name:      "descheduler"
		namespace: "descheduler"
	}
}
res: clusterrole: "coder-amanibhavam-district-cluster-descheduler": cluster: descheduler: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "descheduler"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "descheduler"
			"app.kubernetes.io/version":    "0.29.0"
			"helm.sh/chart":                "descheduler-0.29.0"
		}
		name: "descheduler"
	}
	rules: [{
		apiGroups: ["events.k8s.io"]
		resources: ["events"]
		verbs: [
			"create",
			"update",
		]
	}, {
		apiGroups: [""]
		resources: ["nodes"]
		verbs: [
			"get",
			"watch",
			"list",
		]
	}, {
		apiGroups: [""]
		resources: ["namespaces"]
		verbs: [
			"get",
			"watch",
			"list",
		]
	}, {
		apiGroups: [""]
		resources: ["pods"]
		verbs: [
			"get",
			"watch",
			"list",
			"delete",
		]
	}, {
		apiGroups: [""]
		resources: ["pods/eviction"]
		verbs: ["create"]
	}, {
		apiGroups: ["scheduling.k8s.io"]
		resources: ["priorityclasses"]
		verbs: [
			"get",
			"watch",
			"list",
		]
	}]
}
res: clusterrolebinding: "coder-amanibhavam-district-cluster-descheduler": cluster: descheduler: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "descheduler"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "descheduler"
			"app.kubernetes.io/version":    "0.29.0"
			"helm.sh/chart":                "descheduler-0.29.0"
		}
		name: "descheduler"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "descheduler"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "descheduler"
		namespace: "descheduler"
	}]
}
res: configmap: "coder-amanibhavam-district-cluster-descheduler": descheduler: descheduler: {
	apiVersion: "v1"
	data: "policy.yaml": """
		apiVersion: \"descheduler/v1alpha1\"
		kind: \"DeschedulerPolicy\"
		strategies:
		  LowNodeUtilization:
		    enabled: true
		    params:
		      nodeResourceUtilizationThresholds:
		        targetThresholds:
		          cpu: 50
		          memory: 50
		          pods: 50
		        thresholds:
		          cpu: 20
		          memory: 20
		          pods: 20
		  RemoveDuplicates:
		    enabled: true
		  RemovePodsHavingTooManyRestarts:
		    enabled: true
		    params:
		      podsHavingTooManyRestarts:
		        includingInitContainers: true
		        podRestartThreshold: 100
		  RemovePodsViolatingInterPodAntiAffinity:
		    enabled: true
		  RemovePodsViolatingNodeAffinity:
		    enabled: true
		    params:
		      nodeAffinityType:
		      - requiredDuringSchedulingIgnoredDuringExecution
		  RemovePodsViolatingNodeTaints:
		    enabled: true
		  RemovePodsViolatingTopologySpreadConstraint:
		    enabled: true
		    params:
		      includeSoftConstraints: false

		"""

	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "descheduler"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "descheduler"
			"app.kubernetes.io/version":    "0.29.0"
			"helm.sh/chart":                "descheduler-0.29.0"
		}
		name:      "descheduler"
		namespace: "descheduler"
	}
}
res: cronjob: "coder-amanibhavam-district-cluster-descheduler": descheduler: descheduler: {
	apiVersion: "batch/v1"
	kind:       "CronJob"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "descheduler"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "descheduler"
			"app.kubernetes.io/version":    "0.29.0"
			"helm.sh/chart":                "descheduler-0.29.0"
		}
		name:      "descheduler"
		namespace: "descheduler"
	}
	spec: {
		concurrencyPolicy: "Forbid"
		jobTemplate: spec: template: {
			metadata: {
				annotations: "checksum/config": "13835baebbbcdb83c9614705d835f215659241e412dec6bb0e606fd003e4273c"
				labels: {
					"app.kubernetes.io/instance": "descheduler"
					"app.kubernetes.io/name":     "descheduler"
				}
				name: "descheduler"
			}
			spec: {
				containers: [{
					args: [
						"--policy-config-file=/policy-dir/policy.yaml",
						"--v=3",
					]
					command: ["/bin/descheduler"]
					image:           "registry.k8s.io/descheduler/descheduler:v0.29.0"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						failureThreshold: 3
						httpGet: {
							path:   "/healthz"
							port:   10258
							scheme: "HTTPS"
						}
						initialDelaySeconds: 3
						periodSeconds:       10
					}
					name: "descheduler"
					resources: requests: {
						cpu:    "500m"
						memory: "256Mi"
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						privileged:             false
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						runAsUser:              1000
					}
					volumeMounts: [{
						mountPath: "/policy-dir"
						name:      "policy-volume"
					}]
				}]
				priorityClassName:  "system-cluster-critical"
				restartPolicy:      "Never"
				serviceAccountName: "descheduler"
				volumes: [{
					configMap: name: "descheduler"
					name: "policy-volume"
				}]
			}
		}
		schedule: "*/2 * * * *"
	}
}
