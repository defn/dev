package c

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "dfd": {
		bootstrap: {
			"argo-cd": [1, ""]
			"vc0": [100, ""]
		}
	}
}).outputs
