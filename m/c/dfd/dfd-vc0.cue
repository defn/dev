package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: "dfd-vc0": {
		bootstrap: {
			"argo-cd": [1, ""]
			"kyverno": [2, ""]
		}

		instance_types: []
		parent: env.dfd
	}
}).outputs
