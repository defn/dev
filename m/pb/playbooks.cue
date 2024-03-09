package pb

#username: "ubuntu"

inventory: {
	[string]: vars: {
		// provide defaults for inventory/packer.ini
		ansible_user:            string | *#username
		bazel_remote_cache:      string | *"100.116.216.28" // defn-net-district, because some machines can't have decent DNS
		bazel_remote_cache_port: string | *"9092"
	}

	coder: hosts: [
		"coder-amanibhavam-kowloon",
		"coder-amanibhavam-threesix",
	]

	rpi: hosts: [
		"rpi4a",
		"rpi4b",
		"rpi4c",
	]

	deck: hosts: [
		"steamdeck",
	]

	mac: hosts: [
		"macmini",
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

	district: {
		hosts: [
			"defn-net-district",
		]
		vars: {
			bazel_remote_cache: "cache.defn.run"
		}
	}
}

playbook: base_ubuntu: [{
	name:  "Ubuntu base playbook for all servers"
	hosts: "all"
	roles: [
		"base_packages",
		"base_bazel",
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
	when:   "ansible_architecture != 'aarch64'"
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
}]

role: network_dummy: tasks: [{
	name:   "Configure network dummy netdev"
	become: true
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.netdev.j2"
		dest:  "/etc/systemd/network/dumm1.netdev"
		owner: "root"
		group: "root"
		mode:  "0600"
	}
}, {
	name:   "Configure network dummy network"
	become: true
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.network.j2"
		dest:  "/etc/systemd/network/dumm1.network"
		owner: "root"
		group: "root"
		mode:  "0600"
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
