package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
}

class: {
	handle:     "amanibhavam"
	env:        "district1"
	parent_env: "district"
}
