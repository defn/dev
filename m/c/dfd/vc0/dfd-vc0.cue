package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: "dfd-vc0": {
		bootstrap: {
		}

		instance_types: []
		parent: env.dfd

	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: "dfd-vc0": {
		vc_machine: "dfd"
	}
}).outputs
