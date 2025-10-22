@experiment(aliasv2)
@experiment(explicitopen)

package common

template: "ns.yaml": {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name: chart.name
	}
}
