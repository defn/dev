package c

teacher_handle: string
teacher_env: string

infra_alt_name:    string | *infra_name
infra_account_id:  "510430971399"
infra_k3s_version: "rancher/k3s:v1.27.5-k3s1"

infra_name: string | *"coder-\(teacher_handle)-\(teacher_env)"

infra_vclusters: []

infra_base: {
        domain_name: "\(teacher_env).\(teacher_handle).defn.run"
        domain_slug: "\(teacher_env)-\(teacher_handle)-defn-run"
}

infra_base: {
	domain_zone: "defn.run"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	cloudflare_email: "cloudflare@defn.us"
}

discovery_url: string | *"https://\(infra_alt_name).tail3884f.ts.net"