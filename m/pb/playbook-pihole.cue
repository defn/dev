package pb

playbook: pihole: [{
	name:  "Install pihole service"
	hosts: "rpi3"
	roles: [
		"install_pihole",
	]
}]

role: install_pihole: tasks: [{
	name: "Start/Update pihole container"
	docker_container: {
		name:           "pihole"
		image:          "pihole/pihole:2024.05.0"
		pull:           "missing"
		restart_policy: "unless-stopped"
		env: {
			TZ:                "PST"
			WEBPASSWORD:       "admin"
			PIHOLE_DNS_:       "1.1.1.1"
			DNSMASQ_USER:      "root"
			DNSMASQ_LISTENING: "all"
			FTLCONF_MAXDBDAYS: "180"
		}
		network_mode: "host"
		volumes: [
			"/home/ubuntu/pihole/pihole/:/etc/pihole/",
			"/home/ubuntu/pihole/dnsmasq.d/:/etc/dnsmasq.d/",
		]
	}
}]
