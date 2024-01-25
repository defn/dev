package ansible

inventory: {
	[string]: vars: {
		ansible_user: "ubuntu"
	}

	coder: hosts: [
		"coder-amanibhavam-district",
		//"coder-amanibhavam-school",
		//"coder-amanibhavam-class",
	]

	oci: hosts: [
		"oci1",
		"oci2",
	]

	mac: hosts: [
		//"mba",
		//"mbb",
		"mbair",
		"macmini",
	]

	zimaboard: hosts: [
		"zm1",
		"zm2",
		"zm3",
	]
}

playbook: demo: [{
	name:  "Playbook with one role"
	hosts: "all"
	roles: [
		"base_packages",
	]
}]

playbook: init: [{
	name:  "Playbook to set up root access"
	hosts: "all"
	vars: ansible_user: "root"
	tasks: [{
		name: "Add NOPASSWD to sudoers.d for Ubuntu user"
		copy: {
			content: "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL"
			dest:    "/etc/sudoers.d/ubuntu"
			mode:    "0440"
		}
	}]
}]

role: base_packages: tasks: [{
	name:   "Install base packages"
	become: true
	apt: {
		name: [
			"direnv",
			"make",
			"net-tools",
		]
		state: "present"
	}
}, {
	name:   "Remove packages"
	become: true
	apt: {
		name: [
			"nano",
		]
		state: "absent"
	}
}]
