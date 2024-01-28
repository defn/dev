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
				name:    "defn"
				email:   "iam+bootstrap@defn.sh"
				profile: "org"
			}]
		}

		gyre: {
			region: "us-east-2"
			#types: ops_accounts
			accounts: [{
				name:    "gyre"
				email:   "aws-gyre@defn.us"
				profile: "org"
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
				name:    "curl"
				email:   "aws-curl@defn.us"
				profile: "org"
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
				name:    "coil"
				email:   "aws-coil@defn.us"
				profile: "org"
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
				name:    "helix"
				email:   "aws-helix@defn.sh"
				profile: "org"
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
				name:    "spiral"
				email:   "aws-spiral@defn.us"
				profile: "org"
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
				profile:  "org"
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
				profile:  "org"
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

			accounts: [...{imported: "yes", ...}]

			accounts: [{
				name:    "chamber"
				email:   "aws-chamber@defn.us"
				profile: "org"
			}, {
				name:    "defn-cd"
				email:   "aws-cd@defn.us"
				profile: "1"
			}, {
				name:    "defn-ci"
				email:   "aws-ci@defn.us"
				profile: "2"
			}, {
				name:    "defn-security"
				email:   "aws-users@defn.us"
				profile: "3"
			}, {
				name:    "chamber-4"
				email:   "chamber-4@defn.us"
				profile: "4"
			}, {
				name:    "chamber-5"
				email:   "chamber-5@defn.us"
				profile: "5"
			}, {
				name:    "chamber-6"
				email:   "chamber-6@defn.us"
				profile: "6"
			}, {
				name:    "chamber-7"
				email:   "chamber-7@defn.us"
				profile: "7"
			}, {
				name:    "chamber-8"
				email:   "chamber-8@defn.us"
				profile: "8"
			}, {
				name:    "chamber-9"
				email:   "chamber-9@defn.us"
				profile: "9"
			}, {
				name:    "defn-a"
				email:   "defn-a@imma.io"
				profile: "a"
			}, {
				name:    "defb-b"
				email:   "imma-admin1@imma.io"
				profile: "b"
			}, {
				name:    "defn-c"
				email:   "dev-eng1@imma.io"
				profile: "c"
			}, {
				name:    "defn-d"
				email:   "box-adm1@imma.io"
				profile: "d"
			}, {
				name:    "defn-e"
				email:   "stg-eng1@imma.io"
				profile: "e"
			}, {
				name:    "defn-f"
				email:   "usr-admin1@imma.io"
				profile: "f"
			}, {
				name:    "defn-g"
				email:   "usr-adm1@imma.io"
				profile: "g"
			}, {
				name:    "defn-h"
				email:   "usr-eng1@imma.io"
				profile: "h"
			}, {
				name:    "defn-i"
				email:   "aws-admin1@defn.us"
				profile: "i"
			}, {
				name:    "defn-j"
				email:   "aws-development1@defn.us"
				profile: "j"
			}, {
				name:    "defn-l"
				email:   "aws-staging1@defn.us"
				profile: "l"
			}, {
				name:    "defn-m"
				email:   "defn-m@defn.us"
				profile: "m"
			}, {
				name:    "defn-n"
				email:   "defn-n@defn.us"
				profile: "n"
			}, {
				name:    "defn-o"
				email:   "defn-o@defn.us"
				profile: "o"
			}, {
				name:    "defn-p"
				email:   "defn-p@defn.us"
				profile: "p"
			}, {
				name:    "defn-dev"
				email:   "aws-dev@defn.us"
				profile: "q"
			}, {
				name:    "defn-r"
				email:   "defn-r@imma.io"
				profile: "r"
			}, {
				name:    "defn-s"
				email:   "defn-s@imma.io"
				profile: "s"
			}, {
				name:    "defn-t"
				email:   "defn-t@imma.io"
				profile: "t"
			}, {
				name:    "defn-qa"
				email:   "aws-qa@defn.us"
				profile: "u"
			}, {
				name:    "defn-v"
				email:   "defn-v@imma.io"
				profile: "v"
			}, {
				name:    "defn-w"
				email:   "defn-w@imma.io"
				profile: "w"
			}, {
				name:    "defn-stage"
				email:   "aws-stage@defn.us"
				profile: "x"
			}, {
				name:    "defn-prod"
				email:   "aws-prod@defn.us"
				profile: "y"
			}, {
				name:    "defn-hub"
				email:   "aws-hub@defn.us"
				profile: "z"
			}]
		}

		whoa: {
			region: "us-west-2"
			#types: ["prod", "secrets", "dev", "hub"]
			accounts: [{
				name:     "whoa"
				email:    "aws-whoa@defn.us"
				imported: "yes"
				profile:  "org"
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
			#types1: ["prod", "dev"]
			#types2: ["tolan", "dgwyn", "defn"]
			accounts: [{
				name:     "imma"
				email:    "aws-imma@defn.us"
				imported: "yes"
				profile:  "org"
			}] + [
				for t in #types1 {
					name:     "imma-\(t)"
					email:    "imma-\(t)@imma.io"
					imported: "yes"
					profile:  t
				},
			] + [
				for t in #types2 {
					name:     "imma-\(t)"
					email:    "imma-\(t)@defn.us"
					imported: "yes"
					profile:  t
				},
			]
		}

		immanent: {
			region: "us-west-2"
			#types0: ["patterner", "windkey", "summoner", "herbal", "namer", "ged", "roke", "chanter", "changer", "hand", "doorkeeper"]
			accounts: [{
				name:     "immanent"
				email:    "aws-immanent@defn.us"
				imported: "yes"
				profile:  "org"
			}] + [
				for t in #types0 {
					name:     "immanent-\(t)"
					email:    "immanent-\(t)@defn.us"
					imported: "yes"
					profile:  t
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
				profile:  "org"
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
				profile:  "org"
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
