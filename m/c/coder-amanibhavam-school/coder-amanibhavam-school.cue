package c

teacher: bootstrap: k3s_bootstrap & {
	"spaceship": {}
}

class: {
	handle:          "amanibhavam"
	env:             "school"
	infra_cilium_id: 200
}
