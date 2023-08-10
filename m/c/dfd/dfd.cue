package c

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "dfd": {
		bootstrap: {
			"argo-cd": [1, ""]
			"vc0": [100, ""]
			"vc1": [101, ""]
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		"dfd-vc0": {
			bootstrap: {
				"cert-manager": [2, ""]
			}

			instance_types: []
			parent: env.dfd
		}
		"dfd-vc1": {
			bootstrap: {
				"cert-manager": [2, ""]
			}

			instance_types: []
			parent: env.dfd
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		"vc0": {
			vc_machine: "dfd"
			vc_index: 0
		}
		"vc1": {
			vc_machine: "dfd"
			vc_index: 1
		}
	}
}).outputs
