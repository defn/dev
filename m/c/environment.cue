package c

env: (#Transform & {
	transformer: #TransformVCluster

	inputs: {
		"global-vc0": {
			instance_types: []
			parent: env.global
		}

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
		// global is the global control plane, used by all machines.
		global: {
			bootstrap: {
				"cilium": [1, ""]
				"kyverno": [2, "", "ServerSideApply=true"]
				"coredns": [2, ""]
				"cert-manager": [3, ""]
				"pod-identity-webhook": [10, ""]
				"external-secrets-operator": [10, ""]
				"k3d-global-secrets-store": [20, ""]
				"defn-shared": [30, ""]
				"external-dns": [30, ""]
				"argo-workflows": [40, "argo-workflows", "CreateNamespace=true"]
				"tfo": [40, ""]
				"knative": [40, ""]
				"kourier": [40, ""]
				"defn": [40, ""]
				"traefik": [50, ""]
				"hello": [60, ""]
				"global-vc0": [60, ""]
				"argo-cd": [1000, ""]
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
