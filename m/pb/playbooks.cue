package ansible

inventory: {
	all: hosts: [
		"coder-amanibhavam-district",
		"coder-amanibhavam-school",
		"coder-amanibhavam-class",
	]
}

playbook: demo: [{
	name:  "Playbook with one role"
	hosts: "all"
	roles: ["base_packages"]
}]

role: base_packages: tasks: [{
	name: "Install base packages"
	become: true
	apt: {
		name: [
			"direnv", "make", "net-tools"
		]
		state: "present"
	}
}]
