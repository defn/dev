package api

crd: [crd_name=string]: {
	#plural:   crd_name
	#singular: string
	#kind:     string
	#domain:   string

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

crd: scripts: {
	#domain:   "defn.dev"
	#singular: "script"
	#kind:     "Script"
}

crd: unicorns: {
	#domain:   "pepr.dev"
	#singular: "unicorn"
	#kind:     "Unicorn"
}
