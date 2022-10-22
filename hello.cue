package dev

#Secret: {
	secret_name: string
	secret_key: string
	secret_template: {...} | *null
	secret_refresh: string
	secret_store: string

	out: {
		apiVersion: "external-secrets.io/v1beta1"
		kind:       "ExternalSecret"
		metadata: {
			name: secret_name
			namespace: "default"
		}
		spec: {
			target: {
				name: secret_name
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

// cue export --out yaml -e mehSecret.out > hello.yaml 
// pod delete externalsecret hello; pod apply -f hello.yaml; sleep 2; pod describe externalsecret; pod get secret hello -o json | jq -r '.data["config.yml"] | @base64d'
mehSecret: #Secret & {
	secret_name: "hello"
	secret_key: "/dev/meh"
	secret_template: "config.yml": """
		- https://{{ .user }}:{{ .password }}@api.exmaple.com

		"""
	secret_refresh: "15s"
	secret_store: "dev"
}
