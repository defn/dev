package k

crossplane: provider: cluster: "provider-kubernetes": {
	apiVersion: "pkg.crossplane.io/v1"
	kind:       "Provider"
	metadata: name: "provider-kubernetes"
	spec: {
		package: "xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.11.4"
		runtimeConfigRef: {
			apiVersion: "pkg.crossplane.io/v1beta1"
			kind:       "DeploymentRuntimeConfig"
			name:       "provider-kubernetes"
		}
	}
}

crossplane: deploymentruntimeconfig: cluster: "provider-kubernetes": {
	apiVersion: "pkg.crossplane.io/v1beta1"
	kind:       "DeploymentRuntimeConfig"
	metadata: name: "provider-kubernetes"
	spec: serviceAccountTemplate: metadata: name: "provider-kubernetes"
}

crossplane: clusterrolebinding: cluster: "provider-kubernetes-cluster-admin": {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "provider-kubernetes-cluster-admin"
	subjects: [{
		kind:      "ServiceAccount"
		name:      "provider-kubernetes"
		namespace: "crossplane-system"
	}]
	roleRef: {
		kind:     "ClusterRole"
		name:     "cluster-admin"
		apiGroup: "rbac.authorization.k8s.io"
	}
}

crossplane: providerconfig: cluster: "provider-kubernetes": {
	apiVersion: "kubernetes.crossplane.io/v1alpha1"
	kind:       "ProviderConfig"
	metadata: name: "provider-kubernetes"
	spec: credentials: source: "InjectedIdentity"
}

crossplane: object: cluster: foo: {
	apiVersion: "kubernetes.crossplane.io/v1alpha2"
	kind:       "Object"
	metadata: name: "foo"
	spec: {
		references: [{
			patchesFrom: {
				apiVersion: "v1"
				kind:       "ConfigMap"
				name:       "bar"
				namespace:  "default"
				fieldPath:  "data.sample-key"
			}
			toFieldPath: "data.sample-key-from-bar"
		}]
		forProvider: manifest: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: namespace: "default"
			data: "sample-key":  "foo"
		}
		providerConfigRef: name: "provider-kubernetes"
	}
}

crossplane: configmap: default: bar: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "bar"
		namespace: "default"
	}
	data: "sample-key": "bar"
}
