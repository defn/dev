package c

#VaultSecret: {
	secret_name:      string
	secret_namespace: string
	secret_key:       string
	secret_template:  {...} | *null
	secret_refresh:   string
	secret_store:     string
	secret_type:      string | *"Opaque"

	out: {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name:      secret_name
			namespace: secret_namespace
			annotations: "argocd.argoproj.io/sync-wave": "-1"
		}
		spec: {
			target: {
				name: secret_name
				template: type: secret_type
				if secret_template != null {
					template: data: secret_template
				}
			}

			dataFrom: [{
				extract: key: secret_key
			}]

			refreshInterval: secret_refresh
			secretStoreRef: {
				name: secret_store
				kind: "ClusterSecretStore"
			}
		}
	}
}
