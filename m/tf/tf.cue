package tf

full_accounts: ["ops", "net", "lib", "hub", "log", "sec", "pub", "dev", "dmz"]
env_accounts: ["net", "lib", "hub"]
ops_accounts: ["ops"]

input: {
	backend: {
		lock:    "dfn-defn-terraform-state-lock"
		bucket:  "dfn-defn-terraform-state"
		region:  "us-east-1"
		profile: "defn-org-sso"
	}

	organization: {
		defn: {
			region: "us-east-2"
		}

		gyre: {
			region:   "us-east-2"
			accounts: ops_accounts
		}
		curl: {
			region:   "us-west-2"
			accounts: env_accounts
		}
		coil: {
			region:   "us-east-1"
			accounts: env_accounts
		}
		helix: {
			region:   "us-east-2"
			accounts: full_accounts
			domain:   "defn.sh"
		}
		spiral: {
			region:   "us-west-2"
			accounts: full_accounts
		}

		vault: {
			region: "us-east-2"
		}
		circus: {
			region: "us-west-2"
		}
		chamber: {
			region: "us-west-2"
		}
		whoa: {
			region: "us-west-2"
		}
		imma: {
			region: "us-west-2"
		}
		immanent: {
			region: "us-west-2"
		}
		jianghu: {
			region: "us-west-2"
		}
		fogg: {
			region: "us-west-2"
		}
	}
}
