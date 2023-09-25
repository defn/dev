package l

hooks: "hook": config: {
	configVersion: "v1"
	onStartup:     1
	kubernetes: [{
		name: "ConfigMap"
		apiVersion: "v1"
		kind:       "ConfigMap"
		executeHookOnEvent: [
			"Added",
			"Deleted" 
		]
	}, {
		name: "Pod"
		apiVersion: "v1"
		kind:       "Pod"
		executeHookOnEvent: [
			"Added",
			"Modified",
			"Deleted" 
		]
	}, {
		name: "Secret"
		apiVersion: "v1"
		kind:       "Secret"
		executeHookOnEvent: [
			"Added",
			"Modified",
			"Deleted" 
		]
	}, {
		name: "Namespace"
		apiVersion: "v1"
		kind:       "Namespace"
		executeHookOnEvent: [
			"Added",
			"Modified",
			"Deleted" 
		]
	}]
}
