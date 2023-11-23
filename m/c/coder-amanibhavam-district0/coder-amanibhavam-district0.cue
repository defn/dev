package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
	"external-secrets": {}
	"secrets": {}
	"postgres-operator": {}
	"mastodon": {}
	"argo-cd": {}
}

class: {
	handle:     "amanibhavam"
	env:        "district0"
	parent_env: "district"
}
