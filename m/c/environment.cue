package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		//"global-vc0": {
		//	instance_types: []
		//	parent: env.global
		//}

		[N=string]: {
			bootstrap: {
				"external-secrets-operator": [10, ""]
				"vcluster-global-vc0-secrets-store": [20, ""]
				"coder": [30, ""]
			}
		}
	}
}).outputs

env: (#Transform & {
	transformer: #TransformK3D

	inputs: {
		// dfd is the defn.dev control plane, used by Coder workspaces.
		dfd: {
			bootstrap: {
				"argo-cd": [1, ""]
			}
		}
	}
}).outputs

bootstrap: (#Transform & {
	transformer: #TransformEnvToBootstrapMachine

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:      _env_name
				type:      _env.type
				bootstrap: _env.bootstrap
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformKustomizeVCluster

	inputs: {
		"global-vc0": {
			vc_machine: "global"
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformEnvToAnyResource

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:  _env_name
				type:  _env.type
				label: "\(type)-\(name)"
			}
		}
	}
}).outputs

kustomize: (#Transform & {
	transformer: #TransformEnvToSecretStore

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)": {
				name:  _env_name
				type:  _env.type
				label: "\(type)-\(name)-secrets-store"
			}
		}
	}
}).outputs
