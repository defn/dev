package pb

#username: "ubuntu"

inventory: {
	[string]: vars: {
		// provide defaults for inventory/packer.ini
		ansible_user: string | *#username

		bazel_remote_cache_server: string | *"100.116.216.28" // district
		bazel_remote_cache_port:   string | *"9092"           // public port
		bazel_jobs:                string | *"1"
	}

	cache: hosts: [
		"district",
		"rpi4d",
	]

	cache2: hosts: [
		"rpi4d",
	]

	main: hosts: [
		"macmini", "kowloon",
	]

	hetzner: hosts: [
		"district",
	]

	aws: hosts: [
		"kowloon",
	]

	cloud: children: [
		"aws", "hetzner",
	]

	spiral: children: [
		"mac", "rpi", "zimaboard", "heavy",
	]

	mac: hosts: [
		"macmini",
		"mbair",
		//"mba",
		// mbb is too noisy: fans stay on, load is always 2
		//"mbb",
	]

	chrome: hosts: [
		// "pengu",
		"kinko",
	]

	rpi: children: [
		"rpi3",
		"rpi4",
		//"rpi5",
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
		"rpi4d",
	]

	rpi5: hosts: [
		//"rpi5a",
		//"rpi5b",
		//"rpi5c",
		//"rpi5d",
	]

	zimaboard: hosts: [
		"zm1",
		"zm2",
		"zm3",
	]

	heavy: hosts: [
		"thinkpad",
		"mbpro",
		"fedora",
		"gw",
		"pc",
	]
}
