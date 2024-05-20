package pb

#username: "ubuntu"

inventory: {
	[string]: vars: {
		// provide defaults for inventory/packer.ini
		ansible_user:              string | *#username
		bazel_remote_cache_server: string | *"100.101.80.89" // macmini
		bazel_remote_cache_port:   string | *"9092"          // public port
	}

	cache: {
		children: [
			"hetzner",
			"mac",
		]
	}

	hetzner: {
		hosts: [
			"district",
		]
	}

	aws: {
		hosts: [
			"kowloon",
			"threesix",
		]
	}

	mac: {
		hosts: [
			"macmini",
		]
	}

	chrome: hosts: [
		//"penguin",
	]

	rpi: children: [
		"rpi3",
		"rpi4",
		"rpi5",
	]

	rpi3: hosts: [
		"rpi3a",
		"rpi3b",
		"rpi3c",
	]

	rpi4: hosts: [
		"rpi4a",
		"rpi4b",
		"rpi4c",
	]

	rpi5: hosts: [
		"rpi5a",
		"rpi5b",
		"rpi5c",
		"rpi5d",
	]

	zimaboard: hosts: [
		"zm1",
		"zm2",
		"zm3",
	]

	heavy: hosts: [
		"thinkpad",
		"gw",
	]
}
