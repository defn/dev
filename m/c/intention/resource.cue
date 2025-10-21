package intention

import definition "github.com/defn/dev/m/c/definition"

resource: [NS=string]: [NAME=string]: #ConfigMap & {
	metadata: name:          definition.repo[NAME].name
	metadata: namespace: NS
}

#ConfigMap: {
	apiVersion: "v1"
	data: repo: metadata.name
	kind: "ConfigMap"
	metadata: {
		name:      string
		namespace: string
	}
}
