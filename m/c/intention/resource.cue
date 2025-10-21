package intention

resource: [NS=string]: [NAME=string]: #ConfigMap & {
	data: repo:          NAME
	metadata: namespace: NS
}

#ConfigMap: {
	apiVersion: "v1"
	data: repo: string
	kind: "ConfigMap"
	metadata: {
		name:      data.repo
		namespace: string
	}
}
