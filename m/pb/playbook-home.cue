package pb

playbook: home: [{
	name:  "Install new flakes"
	hosts: "all:!rpi3a:!rpi3b"
	roles: [
		"home_flakes",
	]
}]

playbook: cache: [{
	name:  "Cache new flakes"
	hosts: "cache"
	roles: [
		"home_flakes",
		"home_cache",
	]
}]

role: home_flakes: tasks: [{
	name:  "Install home nix flakes"
	shell: "(pkill -f -9 baze[l] || true) && cd && source .bash_profile && git pull && mise trust && mise install && make nix home"
	args: executable: "/bin/bash"
}]

role: home_cache: tasks: [{
	name:  "Cache all nix flakes"
	shell: "(pkill -f -9 baze[l] || true) && cd && source .bash_profile && git pull && cd m/pkg && mise trust && mise install && j cache"
	args: executable: "/bin/bash"
	register: "home_cache"
	until:    "home_cache is success"
	retries:  3
	delay:    1
}]
