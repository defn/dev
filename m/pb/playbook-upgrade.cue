package pb

playbook: upgrade: [{
	name:   "Upgrade all packages"
	hosts:  "all"
	become: true
	tasks: [{
		name: "Update apt packages"
		apt: {
			upgrade:      "yes"
			update_cache: "yes"
		}
	}]
}]
