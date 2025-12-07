package api

crd: [kind_name=string]: {
	#kind:     kind_name
	#domain:   string
	#plural:   string
	#singular: string

	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: name: "\(#plural).\(#domain)"
	spec: {
		group: #domain
		versions: [{
			name:    "v1"
			served:  true
			storage: true
			schema: openAPIV3Schema: {}
		}]
		scope: "Namespaced"
		names: {
			plural:   #plural
			singular: #singular
			kind:     #kind
		}
	}
}

crd: Script: {
	#domain:   "defn.dev"
	#singular: "script"
	#plural:   "scripts"
}
