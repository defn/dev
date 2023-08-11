package c

cluster_name: "dfd"
cluster_type: "k3d"
vclusters: [0,1]

env: (#Transform & {
	transformer: #TransformK3D

	inputs: "\(cluster_name)": {
		bootstrap: {
			"cert-manager-crds": [1, ""]
			"cert-manager": [2, ""]
			"cilium": [3, ""]
			"argo-cd": [4, ""]
			"\(cluster_type)-\(cluster_name)-vc0": [100, ""]
			"\(cluster_type)-\(cluster_name)-vc1": [100, ""]
			"vcluster-\(cluster_type)-\(cluster_name)-vc0": [200, ""]
			"vcluster-\(cluster_type)-\(cluster_name)-vc1": [200, ""]
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
		"\(cluster_type)-\(cluster_name)-vc0": {
			bootstrap: {
				"cert-manager": [2, ""]
			}
		}
		"\(cluster_type)-\(cluster_name)-vc1": {
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
