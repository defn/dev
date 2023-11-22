package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
	"external-secrets": {}
	"postgres-operator": {}
	"mastodon": {}
}

class: {
	handle:             "amanibhavam"
	env:                "district0"
	parent_env: "district"

}
