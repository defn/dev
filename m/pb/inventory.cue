package pb

#username: "ubuntu"

inventory: {
	all: vars: {
		ansible_user:              string | *#username
		bazel_jobs:                string | *"1"
		bazel_remote_cache_port:   string | *"9092"           // public port
		bazel_remote_cache_server: string | *"100.116.216.28" // district
	}

	"_meta": hostvars: {
		// rpi3a: bazel_remote_cache_server: "192.168.1.26" // macmini
		// rpi3b: bazel_remote_cache_server: "192.168.1.26" // macmini
		// rpi5b: bazel_remote_cache_server: "192.168.1.26" // macmini
	}

	cache: hosts: [
		"district",
		"rpi4c",
		"rpi5c",
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
		//"macmini",
		//"mbair",
		//"mba",
		//"mbb",
	]

	chrome: hosts: [
		"kinko",
		//"pengu",
	]

	tablet: vars: {
		bazel_remote_cache_server: "192.168.1.26" // macmini
	}

	rpi: children: [
		"rpi3",
		"rpi4",
		"rpi5",
	]

	rpi: vars: {
		bazel_remote_cache_server: "192.168.1.26" // macmini
	}

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
		"pc",
		//"mbpro",
	]

	local_cache: hosts: [
		"rpi3a",
		"rpi3b",
		"rpi5b",
	]
}
