package intention

import definition "github.com/defn/dev/m/c/definition"

resource: [NS=string]: [NAME=string]: {
	// Ensure NAME references an existing GitRepo
	definition.repo[NAME]
	#ConfigMap & {
		data: repo:          NAME
		metadata: namespace: NS
	}
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
