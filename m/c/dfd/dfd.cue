package c

cluster_name: "dfd"
cluster_type: "k3d"
vclusters: [0,1]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)": {
		bootstrap: {
			"argo-cd": [1, ""]
			"\(cluster_type)-\(cluster_name)-vc0": [100, ""]
			"\(cluster_type)-\(cluster_name)-vc1": [100, ""]
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		[string]: {
			instance_types: []
			parent: env[cluster_name]
		}
		"\(cluster_name)-vc0": {
			bootstrap: {
				"cert-manager": [2, ""]
			}
		}
		"\(cluster_name)-vc1": {
			bootstrap: {
				"cert-manager": [2, ""]
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		[string]: vc_machine: cluster_name
		for v in vclusters {
			"\(cluster_type)-\(cluster_name)-vc\(v)": vc_index: v
		}
	}
}).outputs
