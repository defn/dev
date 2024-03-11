package cfg

input: {
	backend: {
		lock:    "demonstrate-terraform-remote-state-lock"
		bucket:  "demonstrate-terraform-remote-state"
		profile: "demo-ops-sso"
		region:  "us-west-2"
	}

	organization: {
		demo: {
			name:   "demo"
			region: "us-west-2"

			url: "https://demonstrate.awsapps.com/start"

			ops_org_name:     "demo"
			ops_account_name: "ops"
			ops_account_id:   "992382597334"

			accounts: [{
				name:     "demo"
				profile:  "org"
				email:    "iam+demo-org@defn.sh"
				imported: "yes"
				id:       "992382597334"
			}, {
				name:     "ops"
				profile:  "ops"
				email:    "iam+demo-ops@defn.sh"
				imported: "yes"
				id:       "339712953662"
			}, {
				name:    "net"
				profile: "net"
				email:   "iam+demo-net@defn.sh"
				id:      "851725656107"
			}, {
				name:    "dev"
				profile: "dev"
				email:   "iam+demo-dev@defn.sh"
				id:      "730335323345"
			}]
		}
	}

	// generate list of accounts from organization
	accounts: [
		for oname, org in input.organization
		for aname, acc in org.accounts {
			"\(oname)-\(acc.profile)"
		},
	]
}
