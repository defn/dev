package y

res: clustersecretstore: "coder-amanibhavam-district0-cluster-secrets": cluster: "coder-amanibhavam-district0": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ClusterSecretStore"
	metadata: name: "coder-amanibhavam-district0"
	spec: provider: aws: {
		region:  "us-west-2"
		service: "SecretsManager"
	}
}
