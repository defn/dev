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
		name:  "Autoremove packages"
		shell: "sudo apt -o DPkg::Lock::Timeout=-1 autoremove -y || true"
		args: executable: "/bin/bash"
	}, {
		name: "Update apt packages"
		apt: {
			upgrade:      "yes"
			update_cache: "yes"
		}
		register: "apt_update"
		until:    "apt_update is success"
		retries:  5
		delay:    30
	}, {
		name:  "Autoremove packages"
		shell: "sudo apt -o DPkg::Lock::Timeout=-1 autoremove -y || true"
		args: executable: "/bin/bash"
	}]
}]
