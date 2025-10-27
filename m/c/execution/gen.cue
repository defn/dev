@experiment(aliasv2)
@experiment(explicitopen)

package execution

resource: default: dev: {
	apiVersion: "v1"
	data: repo: "dev"
	kind: "ConfigMap"
	metadata: {
		name:      "dev"
		namespace: "default"
	}
}
resource: default: "nyan-cat": {
	apiVersion: "v1"
	data: repo: "nyan-cat"
	kind: "ConfigMap"
	metadata: {
		name:      "nyan-cat"
		namespace: "default"
	}
}
