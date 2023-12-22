package y

res: clustersecretstore: "coder-amanibhavam-class-cluster-secrets": cluster: "coder-amanibhavam-class": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ClusterSecretStore"
	metadata: name: "coder-amanibhavam-class"
	spec: provider: aws: {
		region:  "us-west-2"
		service: "SecretsManager"
	}
}
