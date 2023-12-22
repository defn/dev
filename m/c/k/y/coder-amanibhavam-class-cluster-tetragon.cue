package y

res: serviceaccount: "coder-amanibhavam-class-cluster-tetragon": "kube-system": tetragon: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon"
		namespace: "kube-system"
	}
}
res: serviceaccount: "coder-amanibhavam-class-cluster-tetragon": "kube-system": "tetragon-operator-service-account": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon-operator"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon-operator-service-account"
		namespace: "kube-system"
	}
}
res: clusterrole: "coder-amanibhavam-class-cluster-tetragon": cluster: tetragon: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name: "tetragon"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"pods",
			"services",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: [
			"tracingpolicies",
			"tracingpoliciesnamespaced",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-tetragon": cluster: "tetragon-operator": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon-operator"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name: "tetragon-operator"
	}
	rules: [{
		apiGroups: [""]
		resources: ["pods"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["cilium.io"]
		resources: ["podinfo"]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"patch",
			"update",
			"watch",
		]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resources: ["customresourcedefinitions"]
		verbs: ["create"]
	}, {
		apiGroups: ["apiextensions.k8s.io"]
		resourceNames: [
			"tracingpolicies.cilium.io",
			"tracingpoliciesnamespaced.cilium.io",
			"podinfo.cilium.io",
		]
		resources: ["customresourcedefinitions"]
		verbs: [
			"update",
			"get",
			"list",
			"watch",
		]
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-tetragon": cluster: tetragon: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name: "tetragon"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "tetragon"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "tetragon"
		namespace: "kube-system"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-tetragon": cluster: "tetragon-operator-rolebinding": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon-operator"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name: "tetragon-operator-rolebinding"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "tetragon-operator"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "tetragon-operator-service-account"
		namespace: "kube-system"
	}]
}
res: configmap: "coder-amanibhavam-class-cluster-tetragon": "kube-system": "tetragon-config": {
	apiVersion: "v1"
	data: {
		"enable-k8s-api":       "true"
		"enable-pod-info":      "false"
		"enable-policy-filter": "true"
		"enable-process-cred":  "false"
		"enable-process-ns":    "false"
		"export-allowlist":     "{\"event_set\":[\"PROCESS_EXEC\", \"PROCESS_EXIT\", \"PROCESS_KPROBE\", \"PROCESS_UPROBE\", \"PROCESS_TRACEPOINT\"]}"

		"export-denylist": """
			{\"health_check\":true}
			{\"namespace\":[\"\", \"cilium\", \"kube-system\"]}
			"""

		"export-file-compress":    "false"
		"export-file-max-backups": "5"
		"export-file-max-size-mb": "10"
		"export-file-perm":        "600"
		"export-filename":         "/var/run/cilium/tetragon/tetragon.log"
		"export-rate-limit":       "-1"
		"field-filters":           "{}"
		"gops-address":            "localhost:8118"
		"metrics-label-filter":    "namespace,workload,pod,binary"
		"metrics-server":          ":2112"
		"process-cache-size":      "65536"
		procfs:                    "/procRoot"
		"server-address":          "localhost:54321"
	}
	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon-config"
		namespace: "kube-system"
	}
}
res: configmap: "coder-amanibhavam-class-cluster-tetragon": "kube-system": "tetragon-operator-config": {
	apiVersion: "v1"
	data: {
		"skip-crd-creation": "false"
		"skip-pod-info-crd": "true"
	}
	kind: "ConfigMap"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon-operator"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon-operator-config"
		namespace: "kube-system"
	}
}
res: service: "coder-amanibhavam-class-cluster-tetragon": "kube-system": tetragon: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon"
		namespace: "kube-system"
	}
	spec: {
		ports: [{
			name:       "metrics"
			port:       2112
			protocol:   "TCP"
			targetPort: 2112
		}]
		selector: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		type: "ClusterIP"
	}
}
res: deployment: "coder-amanibhavam-class-cluster-tetragon": "kube-system": "tetragon-operator": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon-operator"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon-operator"
		namespace: "kube-system"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"app.kubernetes.io/instance": "tetragon"
			"app.kubernetes.io/name":     "tetragon-operator"
		}
		template: {
			metadata: labels: {
				"app.kubernetes.io/instance":   "tetragon"
				"app.kubernetes.io/managed-by": "Helm"
				"app.kubernetes.io/name":       "tetragon-operator"
				"helm.sh/chart":                "tetragon-1.0.1"
			}
			spec: {
				containers: [{
					args: [
						"serve",
						"--config-dir=/etc/tetragon/operator.conf.d/",
					]
					command: ["/usr/bin/tetragon-operator"]
					image:           "quay.io/cilium/tetragon-operator:v1.0.1"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						httpGet: {
							path: "/healthz"
							port: 8081
						}
						initialDelaySeconds: 15
						periodSeconds:       20
					}
					name: "tetragon-operator"
					readinessProbe: {
						httpGet: {
							path: "/readyz"
							port: 8081
						}
						initialDelaySeconds: 5
						periodSeconds:       10
					}
					resources: {
						limits: {
							cpu:    "500m"
							memory: "128Mi"
						}
						requests: {
							cpu:    "10m"
							memory: "64Mi"
						}
					}
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
					}
					volumeMounts: [{
						mountPath: "/etc/tetragon/operator.conf.d/"
						name:      "tetragon-operator-config"
						readOnly:  true
					}]
				}]
				serviceAccountName:            "tetragon-operator-service-account"
				terminationGracePeriodSeconds: 10
				volumes: [{
					configMap: name: "tetragon-operator-config"
					name: "tetragon-operator-config"
				}]
			}
		}
	}
}
res: daemonset: "coder-amanibhavam-class-cluster-tetragon": "kube-system": tetragon: {
	apiVersion: "apps/v1"
	kind:       "DaemonSet"
	metadata: {
		labels: {
			"app.kubernetes.io/instance":   "tetragon"
			"app.kubernetes.io/managed-by": "Helm"
			"app.kubernetes.io/name":       "tetragon"
			"helm.sh/chart":                "tetragon-1.0.1"
		}
		name:      "tetragon"
		namespace: "kube-system"
	}
	spec: {
		selector: matchLabels: {
			"app.kubernetes.io/instance": "tetragon"
			"app.kubernetes.io/name":     "tetragon"
		}
		template: {
			metadata: {
				annotations: "checksum/configmap": "e031669de4a77b6529cd761c5234972944e766233882330feddbde38fb9b4327"
				labels: {
					"app.kubernetes.io/instance":   "tetragon"
					"app.kubernetes.io/managed-by": "Helm"
					"app.kubernetes.io/name":       "tetragon"
					"helm.sh/chart":                "tetragon-1.0.1"
				}
			}
			spec: {
				containers: [{
					args: ["/var/run/cilium/tetragon/tetragon.log"]
					command: ["hubble-export-stdout"]
					env: []
					image:           "quay.io/cilium/hubble-export-stdout:v1.0.3"
					imagePullPolicy: "IfNotPresent"
					name:            "export-stdout"
					resources: {}
					securityContext: {}
					volumeMounts: [{
						mountPath: "/var/run/cilium/tetragon"
						name:      "export-logs"
					}]
				}, {
					args: ["--config-dir=/etc/tetragon/tetragon.conf.d/"]
					env: [{
						name: "NODE_NAME"
						valueFrom: fieldRef: fieldPath: "spec.nodeName"
					}]
					image:           "quay.io/cilium/tetragon:v1.0.1"
					imagePullPolicy: "IfNotPresent"
					livenessProbe: {
						exec: command: [
							"tetra",
							"status",
							"--server-address",
							"localhost:54321",
							"--retries",
							"5",
						]
						timeoutSeconds: 60
					}
					name: "tetragon"
					securityContext: privileged: true
					volumeMounts: [{
						mountPath: "/var/lib/tetragon/metadata"
						name:      "metadata-files"
					}, {
						mountPath: "/etc/tetragon/tetragon.conf.d/"
						name:      "tetragon-config"
						readOnly:  true
					}, {
						mountPath:        "/sys/fs/bpf"
						mountPropagation: "Bidirectional"
						name:             "bpf-maps"
					}, {
						mountPath: "/var/run/cilium"
						name:      "cilium-run"
					}, {
						mountPath: "/var/run/cilium/tetragon"
						name:      "export-logs"
					}, {
						mountPath: "/procRoot"
						name:      "host-proc"
					}]
				}]
				dnsPolicy:                     "Default"
				hostNetwork:                   true
				serviceAccountName:            "tetragon"
				terminationGracePeriodSeconds: 1
				tolerations: [{
					operator: "Exists"
				}]
				volumes: [{
					hostPath: {
						path: "/var/run/cilium"
						type: "DirectoryOrCreate"
					}
					name: "cilium-run"
				}, {
					hostPath: {
						path: "/var/run/cilium/tetragon"
						type: "DirectoryOrCreate"
					}
					name: "export-logs"
				}, {
					configMap: name: "tetragon-config"
					name: "tetragon-config"
				}, {
					hostPath: {
						path: "/sys/fs/bpf"
						type: "DirectoryOrCreate"
					}
					name: "bpf-maps"
				}, {
					hostPath: {
						path: "/proc"
						type: "Directory"
					}
					name: "host-proc"
				}, {
					emptyDir: {}
					name: "metadata-files"
				}]
			}
		}
	}
}
