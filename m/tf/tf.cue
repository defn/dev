package tf

full_accounts: [
	"ops", // operation teams, coder, argocd
	"sec", // security teams
	"net", // network, vpc
	"log", // logging, s3
	"lib", // artifacts, s3, harbor
	"pub", // public resources, elb, s3
	"dmz", // ci/cd, webhooks, buildkite, atlantism bazel-cache
	"hub", // shared services
	"dev", // development environment, frontend, backend, database
]
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
			accounts: [{
				name:  "defn"
				email: "iam+bootstrap@defn.sh"
			}]
		}

		gyre: {
			region: "us-east-2"
			#types: ops_accounts
			accounts: [{
				name:  "gyre"
				email: "aws-gyre@defn.us"
			}] + [
				for t in #types {
					name:  t
					email: "aws-gyre+\(t)@defn.us"
				},
			]
		}
		curl: {
			region:    "us-west-2"
			#types: env_accounts
			accounts: [{
				name:  "curl"
				email: "aws-curl@defn.us"
			}] + [
				for t in #types {
					name:  t
					email: "aws-curl+\(t)@defn.us"
				},
			]
		}
		coil: {
			region:    "us-east-1"
			#types: env_accounts
			accounts: [{
				name:  "coil"
				email: "aws-coil@defn.us"
			}] + [
				for t in #types {
					name:  t
					email: "aws-coil+\(t)@defn.us"
				},
			]
		}
		helix: {
			region:   "us-east-2"
			#types: full_accounts
			accounts: [{
				name:  "helix"
				email: "aws-helix@defn.sh"
			}] + [
				for t in #types {
					name:  t
					email: "aws-helix+\(t)@defn.sh"
				},
			]
		}
		spiral: {
			region:    "us-west-2"
			#types: full_accounts
			accounts: [{
				name:  "spiral"
				email: "aws-spiral@defn.us"
			}] + [
				for t in #types {
					name:  t
					email: "aws-spiral+\(t)@defn.us"
				},
			]
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
			#types: ["gateway", "security", "hub", "postx", "asset", "data", "sandbox", "circus", "home"]
			accounts: [{
				name:  "fogg"
				email: "spiral@defn.sh"
				imported: "yes"
			}] + [
				for t in #types {
					prefix: "fogg-"
					name:  t
					email: "fogg-\(t)@defn.sh"
					imported: "yes"
				},
			]
		}
	}
}
