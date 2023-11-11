package c

env: {...}

bootstrap: (#Transform & {
	transformer: #TransformEnvToBootstrapMachine

	inputs: {
		for _env_name, _env in env {
			"\(_env_name)-env": {
				machine_name: _env_name
				bootstrap:    _env.bootstrap
			}
		}
	}
}).outputs
