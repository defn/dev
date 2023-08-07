package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: "dfd-vc0": {
		bootstrap: {
			"argo-cd": [1, ""]
		}

		instance_types: []
		parent: env.dfd

	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: "vc0": {
		vc_machine: "dfd"
	}
}).outputs
