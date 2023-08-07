package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: "k3d-dfd-vc0": {
		bootstrap: {
			"argo-cd": [1, ""]
		}

		instance_types: []
		parent: env.dfd

	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: "k3d-dfd-vc0": {
		vc_machine: "dfd"
	}
}).outputs
