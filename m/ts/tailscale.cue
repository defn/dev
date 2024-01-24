package tailscale

tagOwners: {
	"tag:amanibhavam": []
	"tag:zimaboard": []
	"tag:thinkpad": []
	"tag:macmini": []
	"tag:mbair": []
	"tag:oracle": []
	"tag:steamdeck": []
	"tag:spiral": []
	"tag:aws": []
	"tag:k8s-admin": []
	"tag:k8s-operator": []
	"tag:k8s": ["tag:k8s-operator"]
}
groups: "group:admins": ["amanibhavam@github", "dgwyn@github"]
hosts: {}
grants: [{
	src: ["group:admins", "tag:amanibhavam"]
	dst: ["tag:k8s-operator"]
	app: "tailscale.com/cap/kubernetes": [{
		impersonate: groups: ["tailscale-admins"]
	}]
}]
acls: [{
	action: "accept"
	src: ["autogroup:member"]
	dst: ["autogroup:self:*"]
}, {
	action: "accept"
	src: ["tag:amanibhavam", "autogroup:member"]
	dst: ["*:53", "*:80", "*:443", "*:22"]
}, {
	action: "accept"
	src: ["*"]
	dst: ["*:9092", "*:1985", "*:51820", "*:53", "*:443"]
}, {
	action: "accept"
	src: ["tag:amanibhavam", "group:admins"]
	dst: ["tag:amanibhavam:*"]
}, {
	action: "accept"
	src: ["group:admins"]
	dst: ["tag:k8s-operator:443"]
}]
ssh: [{
	action: "check"
	src: ["autogroup:member"]
	dst: ["autogroup:self"]
	users: ["autogroup:nonroot", "root"]
}, {
	action: "check"
	src: ["group:admins"]
	dst: ["tag:amanibhavam"]
	users: ["ubuntu", "deck", "root"]
}, {
	action: "accept"
	src: ["tag:amanibhavam"]
	dst: ["tag:amanibhavam"]
	users: ["deck"]
}, {
	action: "check"
	src: ["group:admins"]
	dst: ["tag:oracle"]
	users: ["ubuntu"]
}]
nodeAttrs: [{
	target: ["autogroup:member"]
	attr: ["funnel"]
},
	{target: ["*"], attr: ["funnel"]}]
