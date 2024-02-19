package c

teacher: bootstrap: k3s_bootstrap & {
	"crossdemo": {}
	"xwing": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	cluster_ip:      "172.31.32.164"
	infra_cilium_id: 200
}
