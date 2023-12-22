package y

res: clustersecretstore: "coder-amanibhavam-school-cluster-secrets": cluster: "coder-amanibhavam-school": {
	apiVersion: "external-secrets.io/v1beta1"
	kind:       "ClusterSecretStore"
	metadata: name: "coder-amanibhavam-school"
	spec: provider: aws: {
		region:  "us-west-2"
		service: "SecretsManager"
	}
}
