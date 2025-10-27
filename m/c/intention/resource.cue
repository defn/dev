@experiment(aliasv2)
@experiment(explicitopen)

package intention

import definition "github.com/defn/dev/m/c/definition"

resource: {
	[string]~(NS,_): {
		[string]~(NAME,_): #ConfigMap & {
			metadata: namespace: NS
			if definition.repo[NAME] == _|_ {
				metadata: name: "TODO-repo-not-found-\(NAME)"
			}
		}
	}
}

#ConfigMap: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      string
		namespace: string
	}

	data: repo: string
}
