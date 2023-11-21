package c

teacher: bootstrap: {
	"kyverno": {
		app_sync_options: ["ServerSideApply=true"]
	}
}

class: {
	handle:             "amanibhavam"
	env:                "dev"
	parent_env: "district"

}
