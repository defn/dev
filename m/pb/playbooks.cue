package pb

#username: "ubuntu"

inventory: {
	[string]: vars: {
		// provide defaults for inventory/packer.ini
		ansible_user:              string | *#username
		bazel_remote_cache_server: string | *"macmini.tail3884f.ts.net"
		bazel_remote_cache_port:   string | *"9092"
	}

	mac: {
		hosts: [
			"macmini",
		]
		vars: {
			bazel_remote_cache_server: "cache.defn.run"
			bazel_remote_cache_port:   "9093"
		}
	}

	district: {
		hosts: [
			"district",
		]
		vars: {
			bazel_remote_cache_server: "cache.defn.run"
			bazel_remote_cache_port:   "9093"
		}
	}

	coder: {
		hosts: [
			"kowloon",
			"threesix",
		]
		vars: {
			bazel_remote_cache_server: "district.tail3884f.ts.net"
			bazel_remote_cache_port:   "9092"
		}
	}

	rpi: hosts: [
		"rpi2a",
		"rpi3a",
		"rpi3b",
		"rpi3c",
		"rpi4a",
		"rpi4b",
		"rpi4c",
	]

	zimaboard: hosts: [
		"zm1",
		"zm2",
		"zm3",
	]

	heavy: hosts: [
		"thinkpad",
		"thelio",
	]
}

playbook: base_ubuntu: [{
	name:  "Ubuntu base playbook"
	hosts: "coder:rpi:mac:zimaboard:heavy:district"
	roles: [
		"base_packages",
		"base_bazel",
		"network_dummy",
	]
}]

#init_base: {
	name:  "Playbook to set up root access over ssh"
	hosts: "all"
	tasks: [{
		name: "Add NOPASSWD to sudoers.d for user"
		copy: {
			content: "\(#username) ALL=(ALL:ALL) NOPASSWD: ALL"
			dest:    "/etc/sudoers.d/\(#username)"
			mode:    "0440"
		}
	}]
}

playbook: init: [{
	#init_base
	vars: ansible_user: "root"
}]

playbook: init_local: [{
	#init_base
	become: true
}]

playbook: upgrade: [{
	name:   "Upgrade all packages"
	hosts:  "all"
	become: true
	tasks: [{
		name: "Update apt packages"
		apt: {
			upgrade:      "yes"
			update_cache: "yes"
		}
	}]
}]

playbook: dump: [{
	name:  "Save host inventory"
	hosts: "all"
	tasks: [{
		name:        "Save inventory as json"
		delegate_to: "localhost"
		template: {
			src:  "debug_output.j2"
			dest: "../inventory/dump/{{ inventory_hostname }}.json"
		}
	}, {
		name:        "Convert inventory to CUE"
		delegate_to: "localhost"
		command: """
			cue import -p dump -l '"host"' -l '"{{ inventory_hostname }}"' ../inventory/dump/{{ inventory_hostname }}.json
			"""
	}]
}]

role: base_packages: tasks: [{
	name:   "Install hwe kernel"
	become: true
	when:   "ansible_architecture != 'aarch64' and ansible_architecture != 'armv7l'"
	apt: {
		name: [
			"linux-generic-hwe-22.04",
		]
		state: "present"
	}
}, {
	name:   "Install base packages"
	become: true
	apt: {
		name: [
			"direnv", "make", "net-tools", "lsb-release", "tzdata", "locales",
			"ca-certificates", "iproute2", "sudo", "curl", "build-essential",
			"openssh-client", "rsync", "git", "git-lfs", "fzf", "jq", "gettext",
			"direnv", "ncdu", "apache2-utils", "fontconfig", "docker.io",
			"tzdata", "locales", "sudo", "xz-utils",
		]
		state: "present"
	}
}, {
	name:   "Remove packages"
	become: true
	apt: {
		name: [
			"nano",
			"unattended-upgrades",
		]
		state: "absent"
	}
}, {
	name:   "Remove files"
	become: true
	file: {
		path: [
			"/usr/bin/gs",
		]
		state: "absent"
	}
}, {
	name:   "Allow user to run Docker"
	become: true
	user: {
		name:   #username
		groups: "docker"
		append: "yes"
	}
}, {
	name:   "Create /etc/apt/apt.conf.d directory"
	become: true
	file: {
		path:  "/etc/apt/apt.conf.d"
		state: "directory"
		owner: "root"
		group: "root"
		mode:  "0755"
	}
}, {
	name:   "Delete old apt config"
	become: true
	file: {
		path:  "/etc/apt/apt.conf.d/99-Phased-Updates"
		state: "absent"
	}
}, {
	name:   "Disable and stop unattended-upgrades service"
	become: true
	systemd: {
		name:    "unattended-upgrades"
		enabled: "no"
		state:   "stopped"
	}
}]

role: network_dummy: tasks: [{
	name:   "Configure network dummy netdev"
	become: true
	when:   "ansible_architecture != 'aarch64'"
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.netdev.j2"
		dest:  "/etc/systemd/network/dummy1.netdev"
		owner: "root"
		group: "root"
		mode:  "0644"
	}
}, {
	name:   "Configure network dummy network"
	become: true
	when:   "ansible_architecture != 'aarch64'"
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.network.j2"
		dest:  "/etc/systemd/network/dummy1.network"
		owner: "root"
		group: "root"
		mode:  "0644"
	}
}]

role: base_bazel: tasks: [{
	name:   "Configure bazel cache"
	become: true
	template: {
		src:   "{{ role_path }}/templates/home/\(#username)/m/.bazelrc.user.j2"
		dest:  "/home/\(#username)/m/.bazelrc.user"
		owner: #username
		group: #username
		mode:  "0600"
	}
}]
