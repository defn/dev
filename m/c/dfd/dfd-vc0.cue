package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: "dfd-vc0": {
		bootstrap: {
			"cert-manager": [2, ""]
		}

		instance_types: []
		parent: env.dfd
	}
}).outputs
