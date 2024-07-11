package pb

playbook: upgrade: [{
	name:   "Upgrade all packages"
	hosts:  "all:!fedora"
	become: true
	tasks: [{
		name:  "Fix dpkg"
		shell: "sudo dpkg --configure -a || true"
		args: executable: "/bin/bash"
	}, {
		name:  "Autoremove packages"
		shell: "sudo apt autoremove -y || true"
		args: executable: "/bin/bash"
	}, {
		name: "Update apt packages"
		apt: {
			upgrade:      "yes"
			update_cache: "yes"
		}
	}, {
		name:  "Autoremove packages"
		shell: "sudo apt autoremove -y || true"
		args: executable: "/bin/bash"
	}]
}]
