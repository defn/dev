package c

teacher: bootstrap: k3s_bootstrap & {
	"crossdemo": {}
	"xwing": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	// socat TCP-LISTEN:6444,bind=127.0.0.1,fork TCP:$(ifconfig -a ens5 | grep ' inet ' | awk '{print $2}'):6443
	// tailscale serve --bg --https 6556 https+insecure://127.0.0.1:6555
	cluster_ip:      "coder-amanibhavam-school.tail3884f.ts.net"
	infra_cilium_id: 200
}
