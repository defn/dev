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

	accounts: [
		for oname, org in input.organization
		for aname, acc in org.accounts {
			"\(oname)-\(acc.profile)"
		},
	]

	info: {
		defn: {
			url: "https://defn.awsapps.com/start"
			account: {
				org: {
					id: "510430971399"
				}
			}
		}
		coil: {
			url: "https://d-90674c3cfd.awsapps.com/start"
			account: {
				org: {
					id: "138291560003"
				}
				lib: {
					id: "160764896647"
				}
				net: {
					id: "278790191486"
				}
				hub: {
					id: "453991412409"
				}
			}
		}
		curl: {
			url: "https://d-926760a859.awsapps.com/start"
			account: {
				org: {
					id: "424535767618"
				}
				net: {
					id: "101142583332"
				}
				lib: {
					id: "298406631539"
				}
				hub: {
					id: "804430872255"
				}
			}
		}
		gyre: {
			url: "https://d-9a6716e54a.awsapps.com/start"
			account: {
				org: {
					id: "065163301604"
				}
				ops: {
					id: "319951235442"
				}
			}
		}
		helix: {
			url: "https://d-9a6716ffd1.awsapps.com/start"
			account: {
				org: {
					id: "816178966829"
				}
				sec: {
					id: "018520313738"
				}
				ops: {
					id: "368812692254"
				}
				lib: {
					id: "377857698578"
				}
				hub: {
					id: "436043820387"
				}
				net: {
					id: "504722108514"
				}
				pub: {
					id: "536806623881"
				}
				log: {
					id: "664427926343"
				}
				dmz: {
					id: "724643698007"
				}
				dev: {
					id: "843784871878"
				}
			}
		}
		spiral: {
			url: "https://d-926760b322.awsapps.com/start"
			account: {
				org: {
					id: "232091571197"
				}
				net: {
					id: "057533398557"
				}
				lib: {
					id: "073874947996"
				}
				dmz: {
					id: "130046154300"
				}
				hub: {
					id: "216704421225"
				}
				dev: {
					id: "308726031860"
				}
				pub: {
					id: "371657257885"
				}
				sec: {
					id: "398258703387"
				}
				log: {
					id: "442333715734"
				}
				ops: {
					id: "601164058091"
				}
			}
		}
		fogg: {
			url: "https://fogg-0.awsapps.com/start"
			account: {
				org: {
					id: "328216504962"
				}
				asset: {
					id: "060659916753"
				}
				circus: {
					id: "844609041254"
				}
				data: {
					id: "624713464251"
				}
				gateway: {
					id: "318746665903"
				}
				home: {
					id: "812459563189"
				}
				hub: {
					id: "337248635000"
				}
				postx: {
					id: "565963418226"
				}
				sandbox: {
					id: "442766271046"
				}
				security: {
					id: "372333168887"
				}
			}
		}
		imma: {
			url: "https://imma-0.awsapps.com/start"
			account: {
				org: {
					id: "548373030883"
				}
				defn: {
					id: "246197522468"
				}
				dgwyn: {
					id: "289716781198"
				}
				dev: {
					id: "445584037541"
				}
				prod: {
					id: "766142996227"
				}
				tolan: {
					id: "516851121506"
				}
			}
		}
		immanent: {
			url: "https://immanent-0.awsapps.com/start"
			account: {
				org: {
					id: "545070380609"
				}
				changer: {
					id: "003884504807"
				}
				chanter: {
					id: "071244154667"
				}
				doorkeeper: {
					id: "013267321144"
				}
				ged: {
					id: "640792184178"
				}
				hand: {
					id: "826250190242"
				}
				herbal: {
					id: "165452499696"
				}
				namer: {
					id: "856549015893"
				}
				patterner: {
					id: "143220204648"
				}
				roke: {
					id: "892560628624"
				}
				summoner: {
					id: "397411277587"
				}
				windkey: {
					id: "095764861781"
				}
			}
		}
		whoa: {
			url: "https://whoa-0.awsapps.com/start"
			account: {
				org: {
					id: "389772512117"
				}
				dev: {
					id: "439761234835"
				}
				prod: {
					id: "204827926367"
				}
				secrets: {
					id: "464075062390"
				}
				hub: {
					id: "462478722501"
				}
			}
		}
		chamber: {
			url: "https://chamber-0.awsapps.com/start"
			account: {
				org: {
					id: "730917619329"
				}
				"1": {
					id: "741346472057"
				}
				"2": {
					id: "447993872368"
				}
				"3": {
					id: "463050069968"
				}
				"4": {
					id: "368890376620"
				}
				"5": {
					id: "200733412967"
				}
				"6": {
					id: "493089153027"
				}
				"7": {
					id: "837425503386"
				}
				"8": {
					id: "773314335856"
				}
				"9": {
					id: "950940975070"
				}
				a: {
					id: "503577294851"
				}
				b: {
					id: "310940910494"
				}
				c: {
					id: "047633732615"
				}
				d: {
					id: "699441347021"
				}
				e: {
					id: "171831323337"
				}
				f: {
					id: "842022523232"
				}
				g: {
					id: "023867963778"
				}
				h: {
					id: "371020107387"
				}
				i: {
					id: "290132238209"
				}
				j: {
					id: "738433022197"
				}
				l: {
					id: "991300382347"
				}
				m: {
					id: "684895750259"
				}
				n: {
					id: "705881812506"
				}
				o: {
					id: "307136835824"
				}
				p: {
					id: "706168331526"
				}
				q: {
					id: "217047480856"
				}
				r: {
					id: "416221726155"
				}
				s: {
					id: "840650118369"
				}
				t: {
					id: "490895200523"
				}
				u: {
					id: "467995590869"
				}
				v: {
					id: "979368042862"
				}
				w: {
					id: "313387692116"
				}
				x: {
					id: "834936839208"
				}
				y: {
					id: "153556747817"
				}
				z: {
					id: "037804009879"
				}
			}
		}
		jianghu: {
			url: "https://jianghu-0.awsapps.com/start"
			account: {
				org: {
					id: "657613322961"
				}
				tahoe: {
					id: "025636091251"
				}
				klamath: {
					id: "298431841138"
				}
			}
		}
		vault: {
			url: "https://d-9a672a0e52.awsapps.com/start"
			account: {
				org: {
					id: "475528707847"
				}
				transit: {
					id: "915207860232"
				}
				audit: {
					id: "749185891195"
				}
				vault0: {
					id: "313228123503"
				}
				vault1: {
					id: "040769490632"
				}
				ops: {
					id: "188066400611"
				}
				library: {
					id: "066356637485"
				}
				hub: {
					id: "539099112425"
				}
				pub: {
					id: "851162413429"
				}
				dev: {
					id: "497393606242"
				}
			}
		}
		circus: {
			url: "https://d-92670c4790.awsapps.com/start"
			account: {
				org: {
					id: "036139182623"
				}
				audit: {
					id: "707476523482"
				}
				ops: {
					id: "415618116579"
				}
				transit: {
					id: "002516226222"
				}
				govcloud: {
					id: "497790518354"
				}
			}
		}
	}

	organization: {
		THIS=[string]: accounts: [...{
			region: string | *THIS.region
		}]

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
				name:    "defn-b"
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
