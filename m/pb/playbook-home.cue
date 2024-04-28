package pb

playbook: home: [{
	name:  "install new flakes"
	hosts: "all:!penguin:!rpi3"
	roles: [
		"home_flakes",
	]
}]

role: home_flakes: tasks: [{
	name:  "Install home nix flakes"
	shell: "cd && source .bash_profile && git pull && make home"
	args: executable: "/bin/bash"
}]
