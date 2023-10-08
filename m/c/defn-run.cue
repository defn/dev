package c

infra_base: {
	domain_zone: string | *"defn.run"
	domain_name: string
	domain_slug: string

	secrets_region:   string | *"us-west-2"
	issuer:           string | *"zerossl-production"
	cloudflare_email: string | *"cloudflare@defn.us"
}
