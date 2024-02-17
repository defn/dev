package c

teacher: bootstrap: k3s_bootstrap & {
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
	discovery_url:   "https://d2jcmxt36rf56i.cloudfront.net"
}
