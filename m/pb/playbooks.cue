package pb

playbook: ubuntu: [{
	name:  "Ubuntu playbook"
	hosts: "all:!fedora"
	roles: [
		"base_packages",
		"base_bazel",
		"network_dummy",
		//"hwe_packages",
	]
}]

playbook: rpi: [{
	name:  "rpi playbook"
	hosts: "rpi"
	roles: [
		"base_packages",
		"rpi_packages",
		"network_ethernet",
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

role: hwe_packages: tasks: [{
	name:   "Install hwe kernel"
	become: true
	apt: {
		name: [
			"linux-generic-hwe-22.04",
		]
		state: "present"
	}
}]

role: rpi_packages: tasks: [{
	name:   "Install rpi-specific packages"
	become: true
	apt: {
		name: []
		state: "present"
	}
}]

role: base_packages: tasks: [{
	name:          "Disable unattended-upgrades service"
	become:        true
	ignore_errors: true
	service: {
		name:    "unattended-upgrades"
		enabled: "no"
		state:   "stopped"
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
	name:   "Install base packages"
	become: true
	apt: {
		name: [
			// basics for container images
			"direnv", "curl", "xz-utils", "sudo", "locales", "git",
			"build-essential", "rsync", "python3-venv",
			// for the rest of the build
			"make", "net-tools", "lsb-release", "tzdata", "ca-certificates",
			"iproute2", "openssh-client", "git-lfs", "fzf", "jq", "gettext",
			"direnv", "ncdu", "apache2-utils", "fontconfig", "docker.io",
			"tzdata", "avahi-daemon", "cloud-guest-utils", "ifupdown", "tini",
		]
		state: "present"
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

role: network_ethernet: tasks: [{
	name:   "Configure ethernet network"
	become: true
	template: {
		src:   "{{ role_path }}/templates/etc/network/interfaces.j2"
		dest:  "/etc/network/interfaces"
		owner: "root"
		group: "root"
		mode:  "0644"
	}
}]

role: network_dummy: tasks: [{
	name:          "Configure network dummy netdev"
	become:        true
	ignore_errors: true
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.netdev.j2"
		dest:  "/etc/systemd/network/dummy1.netdev"
		owner: "root"
		group: "root"
		mode:  "0644"
	}
}, {
	name:          "Configure network dummy network"
	become:        true
	ignore_errors: true
	template: {
		src:   "{{ role_path }}/templates/etc/systemd/network/dummy1.network.j2"
		dest:  "/etc/systemd/network/dummy1.network"
		owner: "root"
		group: "root"
		mode:  "0644"
	}
}]

role: base_bazel: tasks: [{
	name: "Creates m directory"
	file: {
		path:  "/home/\(#username)/m"
		state: "directory"
	}
}, {
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
