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
}]
