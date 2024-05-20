package pb

playbook: upgrade: [{
	name:   "Upgrade all packages"
	hosts:  "all"
	become: true
	tasks: [{
		name:  "Fix dpkg"
		shell: "sudo dpkg --configure -a || true"
		args: executable: "/bin/bash"
	}, {
		name: "Update apt packages"
		apt: {
			upgrade:      "yes"
			update_cache: "yes"
		}
	}]
}]
