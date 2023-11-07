package c

import (
	"encoding/yaml"
)

#TransformEnvToAnyResource: {
	from: {
		#Input

		// TODO why is this needed
		vc_name:    string
		vc_machine: string
		type:       string
	}

	to: #KustomizeHelm & {
		_in: from

		helm: {
			release: "bootstrap"
			name:    "any-resource"
			version: "0.1.0"
			repo:    "https://kiwigrid.github.io"
			values: {
				anyResources: {
					for _app_name, _app in bootstrap[_in.name].apps {
						(_app_name): yaml.Marshal(_app.application)
					}
				}
			}
		}
	}
}

#BootstrapConfig: {
	app_wave:         int | *100
	app_namespace:    string | *""
	app_sync_options: [...] | *[]
	...
}

#TransformEnvToBootstrapMachine: {
	from: {
		#Input

		machine_name: string
		bootstrap: [string]: #BootstrapConfig
	}

	to: #BootstrapMachine
}

#BootstrapMachine: {
	_in: #TransformEnvToBootstrapMachine.from

	apps: [string]: #BootstrapApp
	apps: {
		for _app_name, _app in _in.bootstrap {
			(_app_name): #BootstrapApp & {
				machine_name: _in.machine_name
				app_name:     _app_name
			} & _app
		}
	}
}

#BootstrapApp: {
	machine_name:  string
	app_name:      string
	app_namespace: string

	app_version: string | *"main"
	app_repo:    string | *"https://github.com/defn/dev"
	app_type:    string | *"path"
	app_def:     string | *"m/k/r/\(machine_name)-\(app_name)"

	app_wave:         int
	app_sync_options: [...string] | *[]

	application: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"

		metadata: {
			namespace: "argocd"
			name:      "\(machine_name)-\(app_name)"
			annotations: "argocd.argoproj.io/sync-wave": "\(app_wave)"
		}

		spec: {
			project: "default"

			destination: {
				name: machine_name
				if app_namespace != "" {
					namespace: app_namespace
				}
			}

			source: {
				repoURL:        app_repo
				targetRevision: app_version
				(app_type):     app_def
			}

			syncPolicy: {
				automated: {
					prune:    true
					selfHeal: true
				}
				syncOptions: app_sync_options
			}
		}
	}
}

// Machine
#Machine: {
	name: string

	destination: string | *name

	bootstrap: [string]: #BootstrapConfig
	env: #EnvApp
	env: {
		// ex: k/k3d-dfd
		spec: source: path: "m/k/r/\(name)-env"

		spec: "destination": "name": destination
	}
}

#EnvApp: {
	apiVersion: "argoproj.io/v1alpha1"
	kind:       "Application"

	metadata: {
		namespace: "argocd"
		name:      string
	}

	spec: {
		project: "default"

		destination: name:       string
		destination: namespace?: string
		source: {
			repoURL:        "https://github.com/defn/dev"
			targetRevision: "main"
			path:           string
		}

		syncPolicy: automated: {
			prune:    bool | *true
			selfHeal: bool | *true
		}
	}
}

// K3S Machine
#TransformK3S: {
	from: {
		#Input
		bootstrap: [string]: #BootstrapConfig
	}

	to: #K3S
}

#K3S: ctx={
	_in: #TransformK3S.from

	#Machine

	name:      _in.name
	bootstrap: _in.bootstrap

	// ex: k3d-dfd
	env: metadata: name: ctx.name
}
