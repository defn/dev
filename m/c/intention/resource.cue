package intention

import definition "github.com/defn/dev/m/c/definition"

resource: [NS=string]: [NAME=string]: #ConfigMap & {
	if definition.repo[NAME] != _|_ {
		metadata: namespace: NS
		metadata: name: NAME
	}
}

#ConfigMap: {
	apiVersion: "v1"
	kind: "ConfigMap"
	metadata: {
		name:      string
		namespace: string
	}

	data: repo: string
}
