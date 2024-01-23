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
	roles: ["demo"]
}]

role: demo: tasks: [{
	name: "Example task in the role"
	debug: msg: "Hello from example_role!"
}]
