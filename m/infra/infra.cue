package infra

import (
	"list"
	inf "github.com/defn/dev/m/command/infra"
)

full_accounts: [
	"org", // organization master
	"net", // network
	"log", // logging
	"lib", // artifacts
	"ops", // operation teams
	"ci",  // ci/cd
	"hub", // shared services
	"cde", // engineeering teams
	"dev", // development environments
	"pub", // public facing infra
]

input: inf.#AwsProps & {
	#org:       "defn"
	#namespace: "dfn"

	backend: {
		lock:    "\(#namespace)-\(#org)-terraform-state-lock"
		bucket:  "\(#namespace)-\(#org)-terraform-state"
		region:  "us-east-1"
		profile: "defn-org-sso-source"
	}

	organization: {
		THIS=[ORG=string]: {
			ops_org_name:     "defn"
			ops_account_name: "org"
			ops_account_id:   lookup[ops_org_name].accounts[ops_account_name].id

			url: lookup[ORG].url

			#types: [...string]
			accounts: [
				for t in #types {
					{
						profile: t
						name:    lookup[ORG].accounts[t].name
						id:      lookup[ORG].accounts[t].id
						email:   lookup[ORG].accounts[t].email

						prefix:   lookup[ORG].accounts[t].prefix
						imported: lookup[ORG].accounts[t].imported

						region: string | *THIS.region

						cfg: {
							id: "s3-\(ORG)-\(t)"

							enabled:   true
							namespace: #namespace
							stage:     #org
							name:      "global"
							attributes: ["\(ORG)-\(t)"]

							acl:                "private"
							user_enabled:       false
							versioning_enabled: false
						}
					}
				},
			]
		}

		defn: {
			region: "us-east-2"
			#types: ["org"]
		}

		gyre: {
			region: "us-east-2"
			#types: ["org", "ops"]
		}

		curl: {
			region: "us-west-2"
			#types: ["org", "net", "lib", "hub"]
		}

		coil: {
			region: "us-east-1"
			#types: ["org", "net", "lib", "hub"]
		}

		helix: {
			region: "us-east-2"
			#types: full_accounts
		}

		spiral: {
			region: "us-west-2"
			#types: full_accounts
		}

		vault: {
			region: "us-east-2"
			#types: full_accounts
		}

		circus: {
			region: "us-west-2"
			#types: ["org", "net", "log", "lib", "ops"]
		}

		whoa: {
			region: "us-west-2"
			#types: ["org", "net", "hub", "dev", "pub"]
		}

		imma: {
			region: "us-west-2"
			#types: ["org", "net", "log", "lib", "dev", "pub"]
		}

		jianghu: {
			region: "us-west-2"
			#types: ["org", "net", "log"]
		}

		fogg: {
			region: "us-west-2"
			#types: ["org", "net", "log", "lib", "ops", "ci", "hub", "cde", "dev", "pub"]
		}

		chamber: {
			region: "us-west-2"
			// missing k
			#types: list.Concat([["org"], list.Concat([["1", "2", "3", "4", "5", "6", "7", "8", "9"], ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]])])
		}

		immanent: {
			region: "us-west-2"
			#types: ["org", "patterner", "windkey", "summoner", "herbal", "namer", "ged", "roke", "chanter", "changer", "hand", "doorkeeper"]
		}
	}
}

lookup: {
	[ORG=string]: {
		accounts: [ACC=string]: {
			name:     string | *ACC
			prefix:   string | *""
			imported: string | *"no"
			email:    string
		}
	}

	defn: {
		url: "https://defn.awsapps.com/start"
		accounts: {
			org: {
				id:    "510430971399"
				name:  "defn"
				email: "iam+bootstrap@defn.sh"
			}
		}
	}

	coil: {
		url: "https://d-90674c3cfd.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:     string | *ACC
				email: string | *"aws-coil+\(t)@defn.us"
			}
			org: {
				id:    "138291560003"
				name:  "coil"
				email: "aws-coil@defn.us"
			}
			net: {
				id: "278790191486"
			}
			lib: {
				id: "160764896647"
			}
			hub: {
				id: "453991412409"
			}
		}
	}

	curl: {
		url: "https://d-926760a859.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:     string | *ACC
				email: string | *"aws-curl+\(t)@defn.us"
			}
			org: {
				id:    "424535767618"
				name:  "curl"
				email: "aws-curl@defn.us"
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
		accounts: {
			[ACC=string]: {
				t:     string | *ACC
				email: string | *"aws-gyre+\(t)@defn.us"
			}
			org: {
				id:    "065163301604"
				name:  "gyre"
				email: "aws-gyre@defn.us"
			}
			ops: {
				id: "319951235442"
			}
		}
	}

	helix: {
		url: "https://d-9a6716ffd1.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:     string | *ACC
				email: string | *"aws-helix+\(t)@defn.sh"
			}
			org: {
				id:    "816178966829"
				name:  "helix"
				email: "aws-helix@defn.sh"
			}
			net: {
				id: "504722108514"
			}
			log: {
				id: "664427926343"
			}
			lib: {
				id: "377857698578"
			}
			ops: {
				id: "368812692254"
			}
			ci: {
				t:    "sec"
				name: t
				id:   "018520313738"
			}
			hub: {
				id: "436043820387"
			}
			cde: {
				t:    "dmz"
				name: t
				id:   "724643698007"
			}
			dev: {
				id: "843784871878"
			}
			pub: {
				id: "536806623881"
			}
		}
	}

	spiral: {
		url: "https://d-926760b322.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:     string | *ACC
				email: string | *"aws-spiral+\(t)@defn.us"
			}
			org: {
				id:    "232091571197"
				name:  "spiral"
				email: "aws-spiral@defn.us"
			}
			net: {
				id: "057533398557"
			}
			log: {
				id: "442333715734"
			}
			lib: {
				id: "073874947996"
			}
			ops: {
				id: "601164058091"
			}
			ci: {
				t:    "pub"
				name: t
				id:   "371657257885"
			}
			hub: {
				id: "216704421225"
			}
			cde: {
				t:    "sec"
				name: t
				id:   "398258703387"
			}
			dev: {
				id: "308726031860"
			}
			pub: {
				t:    "dmz"
				name: t
				id:   "130046154300"
			}
		}
	}

	fogg: {
		url: "https://fogg-0.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:        string | *ACC
				email:    string | *"fogg-\(t)@defn.sh"
				imported: "yes"
			}

			org: {
				id:    "328216504962"
				name:  "fogg"
				email: "spiral@defn.sh"
			}
			net: {
				t:      "asset"
				name:   t
				id:     "060659916753"
				prefix: "fogg-"
			}
			log: {
				t:      "circus"
				name:   t
				id:     "844609041254"
				prefix: "fogg-"
			}
			lib: {
				t:      "data"
				name:   t
				id:     "624713464251"
				prefix: "fogg-"
			}
			ops: {
				t:      "gateway"
				name:   t
				id:     "318746665903"
				prefix: "fogg-"
			}
			ci: {
				t:      "home"
				name:   t
				id:     "812459563189"
				prefix: "fogg-"
			}
			hub: {
				id:     "337248635000"
				prefix: "fogg-"
			}
			cde: {
				t:      "postx"
				name:   t
				id:     "565963418226"
				prefix: "fogg-"
			}
			dev: {
				t:      "sandbox"
				name:   t
				id:     "442766271046"
				prefix: "fogg-"
			}
			pub: {
				t:      "security"
				name:   t
				id:     "372333168887"
				prefix: "fogg-"
			}
		}
	}

	imma: {
		url: "https://imma-0.awsapps.com/start"
		accounts: {
			org: {
				id:       "548373030883"
				name:     "imma"
				email:    "aws-imma@defn.us"
				imported: "yes"
			}
			net: {
				t:        "defn"
				id:       "246197522468"
				name:     "imma-\(t)"
				email:    "imma-\(t)@defn.us"
				imported: "yes"
			}
			log: {
				t:        "dgwyn"
				id:       "289716781198"
				name:     "imma-\(t)"
				email:    "imma-\(t)@defn.us"
				imported: "yes"
			}
			lib: {
				t:        "tolan"
				id:       "516851121506"
				name:     "imma-\(t)"
				email:    "imma-\(t)@defn.us"
				imported: "yes"
			}
			dev: {
				id:       "445584037541"
				t:        "dev"
				name:     "imma-\(t)"
				email:    "imma-\(t)@imma.io"
				imported: "yes"
			}
			pub: {
				id:       "766142996227"
				t:        "prod"
				name:     "imma-\(t)"
				email:    "imma-\(t)@imma.io"
				imported: "yes"
			}
		}
	}

	immanent: {
		url: "https://immanent-0.awsapps.com/start"
		accounts: {
			[ACC=string]: {
				t:        string | *ACC
				email:    string | *"immanent-\(t)@defn.us"
				imported: "yes"
			}
			org: {
				id:    "545070380609"
				name:  "immanent"
				email: "aws-immanent@defn.us"
			}
			changer: {
				id:   "003884504807"
				name: "immanent-changer"
			}
			chanter: {
				id:   "071244154667"
				name: "immanent-chanter"
			}
			doorkeeper: {
				id:   "013267321144"
				name: "immanent-doorkeeper"
			}
			ged: {
				id:   "640792184178"
				name: "immanent-ged"
			}
			hand: {
				id:   "826250190242"
				name: "immanent-hand"
			}
			herbal: {
				id:   "165452499696"
				name: "immanent-herbal"
			}
			namer: {
				id:   "856549015893"
				name: "immanent-namer"
			}
			patterner: {
				id:   "143220204648"
				name: "immanent-patterner"
			}
			roke: {
				id:   "892560628624"
				name: "immanent-roke"
			}
			summoner: {
				id:   "397411277587"
				name: "immanent-summoner"
			}
			windkey: {
				id:   "095764861781"
				name: "immanent-windkey"
			}
		}
	}

	whoa: {
		url: "https://whoa-0.awsapps.com/start"
		accounts: {
			org: {
				id:       "389772512117"
				name:     "whoa"
				email:    "aws-whoa@defn.us"
				imported: "yes"
			}
			net: {
				t:        "secrets"
				name:     t
				id:       "464075062390"
				email:    "whoa-\(t)@imma.io"
				prefix:   "whoa-"
				imported: "yes"
			}
			hub: {
				t:        "hub"
				id:       "462478722501"
				email:    "whoa-\(t)@imma.io"
				prefix:   "whoa-"
				imported: "yes"
			}
			dev: {
				t:        "dev"
				id:       "439761234835"
				email:    "whoa-\(t)@imma.io"
				prefix:   "whoa-"
				imported: "yes"
			}
			pub: {
				t:        "prod"
				name:     t
				id:       "204827926367"
				email:    "whoa-\(t)@imma.io"
				prefix:   "whoa-"
				imported: "yes"
			}
		}
	}

	chamber: {
		url: "https://chamber-0.awsapps.com/start"
		accounts: {
			[string]: imported: "yes"
			org: {
				id:    "730917619329"
				name:  "chamber"
				email: "aws-chamber@defn.us"
			}
			"1": {
				id:    "741346472057"
				name:  "defn-cd"
				email: "aws-cd@defn.us"
			}
			"2": {
				id:    "447993872368"
				name:  "defn-ci"
				email: "aws-ci@defn.us"
			}
			"3": {
				id:    "463050069968"
				name:  "defn-security"
				email: "aws-users@defn.us"
			}
			"4": {
				id:    "368890376620"
				name:  "chamber-4"
				email: "chamber-4@defn.us"
			}
			"5": {
				id:    "200733412967"
				name:  "chamber-5"
				email: "chamber-5@defn.us"
			}
			"6": {
				id:    "493089153027"
				name:  "chamber-6"
				email: "chamber-6@defn.us"
			}
			"7": {
				id:    "837425503386"
				name:  "chamber-7"
				email: "chamber-7@defn.us"
			}
			"8": {
				id:    "773314335856"
				name:  "chamber-8"
				email: "chamber-8@defn.us"
			}
			"9": {
				id:    "950940975070"
				name:  "chamber-9"
				email: "chamber-9@defn.us"
			}
			a: {
				id:    "503577294851"
				name:  "defn-a"
				email: "defn-a@imma.io"
			}
			b: {
				id:    "310940910494"
				name:  "defn-b"
				email: "imma-admin1@imma.io"
			}
			c: {
				id:    "047633732615"
				name:  "defn-c"
				email: "dev-eng1@imma.io"
			}
			d: {
				id:    "699441347021"
				name:  "defn-d"
				email: "box-adm1@imma.io"
			}
			e: {
				id:    "171831323337"
				name:  "defn-e"
				email: "stg-eng1@imma.io"
			}
			f: {
				id:    "842022523232"
				name:  "defn-f"
				email: "usr-admin1@imma.io"
			}
			g: {
				id:    "023867963778"
				name:  "defn-g"
				email: "usr-adm1@imma.io"
			}
			h: {
				id:    "371020107387"
				name:  "defn-h"
				email: "usr-eng1@imma.io"
			}
			i: {
				id:    "290132238209"
				name:  "defn-i"
				email: "aws-admin1@defn.us"
			}
			j: {
				id:    "738433022197"
				name:  "defn-j"
				email: "aws-development1@defn.us"
			}
			l: {
				id:    "991300382347"
				name:  "defn-l"
				email: "aws-staging1@defn.us"
			}
			m: {
				id:    "684895750259"
				name:  "defn-m"
				email: "defn-m@defn.us"
			}
			n: {
				id:    "705881812506"
				name:  "defn-n"
				email: "defn-n@defn.us"
			}
			o: {
				id:    "307136835824"
				name:  "defn-o"
				email: "defn-o@defn.us"
			}
			p: {
				id:    "706168331526"
				name:  "defn-p"
				email: "defn-p@defn.us"
			}
			q: {
				id:    "217047480856"
				name:  "defn-dev"
				email: "aws-dev@defn.us"
			}
			r: {
				id:    "416221726155"
				name:  "defn-r"
				email: "defn-r@imma.io"
			}
			s: {
				id:    "840650118369"
				name:  "defn-s"
				email: "defn-s@imma.io"
			}
			t: {
				id:    "490895200523"
				name:  "defn-t"
				email: "defn-t@imma.io"
			}
			u: {
				id:    "467995590869"
				name:  "defn-qa"
				email: "aws-qa@defn.us"
			}
			v: {
				id:    "979368042862"
				name:  "defn-v"
				email: "defn-v@imma.io"
			}
			w: {
				id:    "313387692116"
				name:  "defn-w"
				email: "defn-w@imma.io"
			}
			x: {
				id:    "834936839208"
				name:  "defn-stage"
				email: "aws-stage@defn.us"
			}
			y: {
				id:    "153556747817"
				name:  "defn-prod"
				email: "aws-prod@defn.us"
			}
			z: {
				id:    "037804009879"
				name:  "defn-hub"
				email: "aws-hub@defn.us"
			}
		}
	}

	jianghu: {
		url: "https://jianghu-0.awsapps.com/start"
		accounts: {
			org: {
				id:       "657613322961"
				name:     "jianghu"
				email:    "aws-jianghu@defn.us"
				imported: "yes"
			}
			net: {
				t:        "tahoe"
				name:     t
				id:       "025636091251"
				email:    "\(t)@defn.us"
				imported: "yes"
			}
			log: {
				t:        "klamath"
				name:     t
				id:       "298431841138"
				email:    "\(t)@defn.us"
				imported: "yes"
			}
		}
	}

	vault: {
		url: "https://d-9a672a0e52.awsapps.com/start"
		accounts: {
			org: {
				id:       "475528707847"
				name:     "vault"
				email:    "aws-vault@defn.us"
				imported: "yes"
			}
			net: {
				t:        "transit"
				name:     t
				id:       "915207860232"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			log: {
				t:        "audit"
				name:     t
				id:       "749185891195"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			lib: {
				t:        "library"
				name:     t
				id:       "066356637485"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			ops: {
				t:        "ops"
				id:       "188066400611"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			ci: {
				t:        "vault0"
				name:     t
				id:       "313228123503"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			hub: {
				t:        "hub"
				id:       "539099112425"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			cde: {
				t:        "vault1"
				name:     t
				id:       "040769490632"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			dev: {
				t:        "dev"
				id:       "497393606242"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
			pub: {
				t:        "pub"
				id:       "851162413429"
				email:    "aws-vault-\(t)@defn.sh"
				imported: "yes"
			}
		}
	}

	circus: {
		url: "https://d-92670c4790.awsapps.com/start"
		accounts: {
			org: {
				id:       "036139182623"
				name:     "circus"
				email:    "aws-circus@defn.us"
				imported: "yes"
			}
			net: {
				t:        "transit"
				name:     t
				id:       "002516226222"
				email:    "aws-circus-\(t)@defn.sh"
				imported: "yes"
			}
			log: {
				t:        "audit"
				name:     t
				id:       "707476523482"
				email:    "aws-circus-\(t)@defn.sh"
				imported: "yes"
			}
			lib: {
				t:        "govcloud"
				name:     t
				id:       "497790518354"
				email:    "aws-circus-\(t)@defn.sh"
				imported: "yes"
			}
			ops: {
				t:        "ops"
				id:       "415618116579"
				email:    "aws-circus-\(t)@defn.sh"
				imported: "yes"
			}
		}
	}
}
