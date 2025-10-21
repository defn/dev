package main

resources: default: "dev-db7ddb9b59": {
	apiVersion: "v1"
	data: repo: "dev"
	kind: "ConfigMap"
	metadata: {
		name:      "dev-db7ddb9b59"
		namespace: "default"
	}
}
resources: default: "nyan-cat-4mhth8gdk2": {
	apiVersion: "v1"
	data: repo: "nyan-cat"
	kind: "ConfigMap"
	metadata: {
		name:      "nyan-cat-4mhth8gdk2"
		namespace: "default"
	}
}
