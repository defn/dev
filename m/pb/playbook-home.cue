package pb

playbook: home: [{
	name:  "Install new flakes"
	hosts: "all:!rpi3"
	roles: [
		"home_flakes",
	]
}]

playbook: cache: [{
	name:  "Cache new flakes"
	hosts: "cache"
	roles: [
		"home_flakes",
	]
}]

role: home_flakes: tasks: [{
	name:  "Install home nix flakes"
	shell: "(pkill -f -9 baze[l] || true) && cd && source .bash_profile && git pull && make home"
	args: executable: "/bin/bash"
}]
