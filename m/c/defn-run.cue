package c

infra_alt_name:    string | *infra_name
infra_account_id:  "510430971399"
infra_k3s_version: "rancher/k3s:v1.27.5-k3s1"

infra_base: {
	domain_zone: "defn.run"

	secrets_region:   "us-west-2"
	issuer:           "zerossl-production"
	cloudflare_email: "cloudflare@defn.us"
}
