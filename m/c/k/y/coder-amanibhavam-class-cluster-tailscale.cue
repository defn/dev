package y

res: namespace: "coder-amanibhavam-class-cluster-tailscale": cluster: tailscale: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: "tailscale"
}
res: serviceaccount: "coder-amanibhavam-class-cluster-tailscale": tailscale: operator: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "operator"
		namespace: "tailscale"
	}
}
res: serviceaccount: "coder-amanibhavam-class-cluster-tailscale": tailscale: proxies: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "proxies"
		namespace: "tailscale"
	}
}
res: role: "coder-amanibhavam-class-cluster-tailscale": tailscale: operator: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		name:      "operator"
		namespace: "tailscale"
	}
	rules: [{
		apiGroups: [""]
		resources: ["secrets"]
		verbs: ["*"]
	}, {
		apiGroups: ["apps"]
		resources: ["statefulsets"]
		verbs: ["*"]
	}]
}
res: role: "coder-amanibhavam-class-cluster-tailscale": tailscale: proxies: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		name:      "proxies"
		namespace: "tailscale"
	}
	rules: [{
		apiGroups: [""]
		resources: ["secrets"]
		verbs: ["*"]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-tailscale": cluster: "tailscale-auth-proxy": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name: "tailscale-auth-proxy"
	rules: [{
		apiGroups: [""]
		resources: [
			"users",
			"groups",
		]
		verbs: ["impersonate"]
	}]
}
res: clusterrole: "coder-amanibhavam-class-cluster-tailscale": cluster: "tailscale-operator": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name: "tailscale-operator"
	rules: [{
		apiGroups: [""]
		resources: [
			"events",
			"services",
			"services/status",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["networking.k8s.io"]
		resources: [
			"ingresses",
			"ingresses/status",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["tailscale.com"]
		resources: [
			"connectors",
			"connectors/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"update",
		]
	}]
}
res: rolebinding: "coder-amanibhavam-class-cluster-tailscale": tailscale: operator: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "operator"
		namespace: "tailscale"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "operator"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "operator"
		namespace: "tailscale"
	}]
}
res: rolebinding: "coder-amanibhavam-class-cluster-tailscale": tailscale: proxies: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "proxies"
		namespace: "tailscale"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "proxies"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "proxies"
		namespace: "tailscale"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-tailscale": cluster: "tailscale-admins-cluster-admin": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "tailscale-admins-cluster-admin"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [{
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Group"
		name:     "tailscale-admins"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-tailscale": cluster: "tailscale-auth-proxy": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "tailscale-auth-proxy"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "tailscale-auth-proxy"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "operator"
		namespace: "tailscale"
	}]
}
res: clusterrolebinding: "coder-amanibhavam-class-cluster-tailscale": cluster: "tailscale-operator": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "tailscale-operator"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "tailscale-operator"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "operator"
		namespace: "tailscale"
	}]
}
res: secret: "coder-amanibhavam-class-cluster-tailscale": tailscale: "not-used": {
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "not-used"
		namespace: "tailscale"
	}
	stringData: {
	}
}
res: deployment: "coder-amanibhavam-class-cluster-tailscale": tailscale: operator: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "operator"
		namespace: "tailscale"
	}
	spec: {
		replicas: 1
		selector: matchLabels: app: "operator"
		strategy: type: "Recreate"
		template: {
			metadata: labels: app: "operator"
			spec: {
				containers: [{
					env: [{
						name:  "OPERATOR_HOSTNAME"
						value: "coder-amanibhavam-class-proxy"
					}, {
						name:  "OPERATOR_SECRET"
						value: "operator"
					}, {
						name:  "OPERATOR_LOGGING"
						value: "dev"
					}, {
						name: "OPERATOR_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name:  "ENABLE_CONNECTOR"
						value: "false"
					}, {
						name:  "CLIENT_ID_FILE"
						value: "/oauth/client_id"
					}, {
						name:  "CLIENT_SECRET_FILE"
						value: "/oauth/client_secret"
					}, {
						name:  "PROXY_IMAGE"
						value: "tailscale/tailscale:unstable"
					}, {
						name:  "PROXY_TAGS"
						value: "tag:k8s"
					}, {
						name:  "APISERVER_PROXY"
						value: "true"
					}, {
						name:  "PROXY_FIREWALL_MODE"
						value: "auto"
					}]
					image:           "tailscale/k8s-operator:unstable"
					imagePullPolicy: "Always"
					name:            "operator"
					volumeMounts: [{
						mountPath: "/not-used"
						name:      "not-used"
						readOnly:  true
					}, {
						mountPath: "/oauth"
						name:      "oauth"
						readOnly:  true
					}]
				}]
				nodeSelector: "kubernetes.io/os": "linux"
				serviceAccountName: "operator"
				volumes: [{
					name: "not-used"
					secret: secretName: "not-used"
				}, {
					name: "oauth"
					secret: secretName: "operator-oauth-custom"
				}]
			}
		}
	}
}
res: externalsecret: "coder-amanibhavam-class-cluster-tailscale": tailscale: "operator-oauth-custom": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ExternalSecret"
	metadata: {
		name:      "operator-oauth-custom"
		namespace: "tailscale"
	}
	spec: {
		dataFrom: [{
			extract: key: "coder-amanibhavam-class-cluster"
		}]
		refreshInterval: "1h"
		secretStoreRef: {
			kind: "ClusterSecretStore"
			name: "coder-amanibhavam-class"
		}
		target: {
			creationPolicy: "Owner"
			name:           "operator-oauth-custom"
		}
	}
}
