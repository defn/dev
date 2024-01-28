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
			region: "us-west-2"

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
			region: "us-east-1"
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
			region: "us-east-2"
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
			region: "us-west-2"
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
			#types: ["transit", "audit", "vault0", "vault1", "ops", "library", "hub", "pub", "dev"]
			accounts: [{
				name:     "vault"
				email:    "aws-vault@defn.us"
				imported: "yes"
			}] + [
				for t in #types {
					name:     t
					email:    "aws-vault-\(t)@defn.sh"
					imported: "yes"
				},
			]
		}

		circus: {
			region: "us-west-2"
			#types: ["audit", "govcloud", "ops", "transit"]
			accounts: [{
				name:     "circus"
				email:    "aws-circus@defn.us"
				imported: "yes"
			}] + [
				for t in #types {
					name:     t
					email:    "aws-circus-\(t)@defn.sh"
					imported: "yes"
				},
			]
		}
		chamber: {
			region: "us-west-2"

			accounts: [{
				name: "chamber", email: "aws-chamber@defn.us"
			}, {
				name: "chamber-4", email: "chamber-4@defn.us"
			}, {
				name: "chamber-5", email: "chamber-5@defn.us"
			}, {
				name: "chamber-6", email: "chamber-6@defn.us"
			}, {
				name: "chamber-7", email: "chamber-7@defn.us"
			}, {
				name: "chamber-8", email: "chamber-8@defn.us"
			}, {
				name: "chamber-9", email: "chamber-9@defn.us"
			}, {
				name: "defn-m", email: "defn-m@defn.us"
			}, {
				name: "defn-n", email: "defn-n@defn.us"
			}, {
				name: "defn-o", email: "defn-o@defn.us"
			}, {
				name: "defn-p", email: "defn-p@defn.us"
			}, {
				name: "defn-r", email: "defn-r@imma.io"
			}, {
				name: "defn-s", email: "defn-s@imma.io"
			}, {
				name: "defn-t", email: "defn-t@imma.io"
			}, {
				name: "defn-v", email: "defn-v@imma.io"
			}, {
				name: "defn-w", email: "defn-w@imma.io"
			}, {
				name: "defn-i", email: "aws-admin1@defn.us"
			}, {
				name: "defn-j", email: "aws-development1@defn.us"
			}, {
				name: "defn-k", email: "aws-production1@defn.us"
			}, {
				name: "defn-l", email: "aws-staging1@defn.us"
			}, {
				name: "defn-a", email: "defn-a@imma.io"
			}, {
				name: "defn-b", email: "imma-admin1@imma.io"
			}, {
				name: "defn-c", email: "dev-eng1@imma.io"
			}, {
				name: "defn-d", email: "box-adm1@imma.io"
			}, {
				name: "defn-e", email: "stg-eng1@imma.io"
			}, {
				name: "defn-f", email: "usr-admin1@imma.io"
			}, {
				name: "defn-g", email: "usr-adm1@imma.io"
			}, {
				name: "defn-h", email: "usr-eng1@imma.io"
			}, {
				name: "defn-hub", email: "aws-hub@defn.us"
			}, {
				name: "defn-prod", email: "aws-prod@defn.us"
			}, {
				name: "defn-qa", email: "aws-qa@defn.us"
			}, {
				name: "defn-security", email: "aws-users@defn.us"
			}, {
				name: "defn-stage", email: "aws-stage@defn.us"
			}, {
				name: "defn-cd", email: "aws-cd@defn.us"
			}, {
				name: "defn-ci", email: "aws-ci@defn.us"
			}, {
				name: "defn-dev", email: "aws-dev@defn.us"
			}]
		}
		whoa: {
			region: "us-west-2"
			#types: ["prod", "secrets", "dev", "hub"]
			accounts: [{
				name:     "whoa"
				email:    "aws-whoa@defn.us"
				imported: "yes"
			}] + [
				for t in #types {
					prefix:   "whoa-"
					name:     t
					email:    "whoa-\(t)@imma.io"
					imported: "yes"
				},
			]
		}
		imma: {
			region: "us-west-2"
			#types1: ["imma-prod", "imma-dev"]
			#types2: ["imma-tolan", "imma-dgwyn", "imma-defn"]
			accounts: [{
				name:     "imma"
				email:    "aws-imma@defn.us"
				imported: "yes"
			}] + [
				for t in #types1 {
					name:     t
					email:    "\(t)@imma.io"
					imported: "yes"
				},
			] + [
				for t in #types2 {
					name:     t
					email:    "\(t)@defn.us"
					imported: "yes"
				},
			]
		}

		immanent: {
			region: "us-west-2"
			#types0: ["patterner", "windkey", "summoner", "herbal", "namer", "ged", "roke", "chanter", "changer", "hand", "doorkeeper"]
			#types: [
				for t in #types0 {
					"immanent-\(t)"
				},
			]
			accounts: [{
				name:     "immanent"
				email:    "aws-immanent@defn.us"
				imported: "yes"
			}] + [
				for t in #types {
					name:     t
					email:    "\(t)@defn.us"
					imported: "yes"
				},
			]
		}

		jianghu: {
			region: "us-west-2"
			#types: ["tahoe", "klamath"]
			accounts: [{
				name:     "jianghu"
				email:    "aws-jianghu@defn.us"
				imported: "yes"
			}] + [
				for t in #types {
					name:     t
					email:    "\(t)@defn.us"
					imported: "yes"
				},
			]
		}
		fogg: {
			region: "us-west-2"
			#types: ["gateway", "security", "hub", "postx", "asset", "data", "sandbox", "circus", "home"]
			accounts: [{
				name:     "fogg"
				email:    "spiral@defn.sh"
				imported: "yes"
			}] + [
				for t in #types {
					prefix:   "fogg-"
					name:     t
					email:    "fogg-\(t)@defn.sh"
					imported: "yes"
				},
			]
		}
	}
}
