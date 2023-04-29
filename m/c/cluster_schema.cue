package c

cluster: [NAME=string]: #Cluster & {cluster_name: NAME}

#Cluster: ctx={
	cluster_name: string
	k3d_name:     string | *"k3d-\(cluster_name)"
	domain:       string
	mpath:        string
	kube_config:  string | *"~/.kube/config"

	// Passthrough Terraform locals, module config
	locals: [...{...}] | *[{envs: {}}]
	module: [string]: [...{...}]

	// Terraform hcl.json output
	out: {
		terraform: backend: kubernetes: [{
			secret_suffix:  "state-\(k3d_name)"
			config_path:    "~/.kube/config"
			config_context: k3d_name
		}]

		provider: kubernetes: [{
			config_context: k3d_name
			config_path:    kube_config
		}]

		locals: ctx.locals

		if len(ctx.module) > 0 {
			module: ctx.module
		}
	}
}

#DevPod: ctx=#Cluster & {
	// Configure cluster
	locals: [{
		envs: "\(ctx.cluster_name)": {
			domain: ctx.domain
			host:   ctx.k3d_name
		}
	}]

	// Deploy a dev pod with the above configuration
	module: devpod: [{
		source: "\(ctx.mpath)/devpod"
		envs:   "${local.envs}"
	}]
}
