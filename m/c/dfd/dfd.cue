package c

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "dfd": {
		bootstrap: {
			"argo-cd": [1, ""]
			"k3d-dfd-vc0": [100, ""]
		}
	}
}).outputs
