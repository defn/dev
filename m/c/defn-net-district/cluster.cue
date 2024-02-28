package c

class: {
	handle:          "net"
	env:             "district"
	infra_cilium_id: 250
}

teacher: bootstrap: k3s_bootstrap & {
}

kustomize: cilium: helm: values: hubble: ui: enabled: true
kustomize: coder: helm: namespace: "defn-\(class.env)"
