package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
	"external-secrets": {}
	"secrets": {}
	"postgres-operator": {}
	"argo-cd": {}
}

class: {
	handle:     "{{cookiecutter.handle}}"
	env:        "{{cookiecutter.env}}"
	parent_env: "{{cookiecutter.parent_env}}"
}
