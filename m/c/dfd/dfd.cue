package c

vclusters: [0,1]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "dfd": {
		bootstrap: {
			"argo-cd": [1, ""]
			for v in vclusters {
				"vc\(v)": [100, ""]
			}
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		[string]: {
			instance_types: []
			parent: env.dfd
		}
		"dfd-vc0": {
			bootstrap: {
				"cert-manager": [2, ""]
			}
		}
		"dfd-vc1": {
			bootstrap: {
				"cert-manager": [2, ""]
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		[string]: vc_machine: "dfd"
		for v in vclusters {
			"vc\(v)": vc_index: v
		}
	}
}).outputs
