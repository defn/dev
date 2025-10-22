package aws

org: [ORG=string]: close({
	region: "us-west-2" | "us-east-2" | "us-east-1"
	url:    =~"https://[a-z0-9-]+.awsapps.com/start"
	account: [ACCOUNT=string]: close({
		account:   ACCOUNT
		org:       ORG
		id!:       =~"^[0-9]+$"
		sso_role!: "Administrator"
		email!:    string
		name!:     string

		prefix:   string | *""
		imported: "yes" | *"no"

		t: string | *ACCOUNT
	})
})

// aws account metadata
org: {
	chamber: {
		region: "us-west-2"
		url:    "https://chamber-0.awsapps.com/start"
	}
	circus: {
		region: "us-west-2"
		url:    "https://d-92670c4790.awsapps.com/start"
	}
	coil: {
		region: "us-east-1"
		url:    "https://d-90674c3cfd.awsapps.com/start"
	}
	curl: {
		region: "us-west-2"
		url:    "https://d-926760a859.awsapps.com/start"
	}
	defn: {
		region: "us-east-2"
		url:    "https://defn.awsapps.com/start"
	}
	fogg: {
		region: "us-west-2"
		url:    "https://fogg-0.awsapps.com/start"
	}
	gyre: {
		region: "us-east-2"
		url:    "https://d-9a6716e54a.awsapps.com/start"
	}
	helix: {
		region: "us-east-2"
		url:    "https://d-9a6716ffd1.awsapps.com/start"
	}
	imma: {
		region: "us-west-2"
		url:    "https://imma-0.awsapps.com/start"
	}
	immanent: {
		region: "us-west-2"
		url:    "https://immanent-0.awsapps.com/start"
	}
	jianghu: {
		region: "us-west-2"
		url:    "https://jianghu-0.awsapps.com/start"
	}
	spiral: {
		region: "us-west-2"
		url:    "https://d-926760b322.awsapps.com/start"
	}
	vault: {
		region: "us-east-2"
		url:    "https://d-9a672a0e52.awsapps.com/start"
	}
	whoa: {
		region: "us-west-2"
		url:    "https://whoa-0.awsapps.com/start"
	}
}

// list the accounts
org: {
	chamber: account: {
		org: {
			id:       "730917619329"
			email:    "aws-chamber@defn.us"
			sso_role: "Administrator"
			name:     "chamber"
			imported: "yes"
		}
		"1": {
			id:       "741346472057"
			email:    "aws-cd@defn.us"
			sso_role: "Administrator"
			name:     "defn-cd"
			imported: "yes"
		}
		"2": {
			id:       "447993872368"
			email:    "aws-ci@defn.us"
			sso_role: "Administrator"
			name:     "defn-ci"
			imported: "yes"
		}
		"3": {
			id:       "463050069968"
			email:    "aws-users@defn.us"
			sso_role: "Administrator"
			name:     "defn-security"
			imported: "yes"
		}
		"4": {
			id:       "368890376620"
			email:    "chamber-4@defn.us"
			sso_role: "Administrator"
			name:     "chamber-4"
			imported: "yes"
		}
		"5": {
			id:       "200733412967"
			email:    "chamber-5@defn.us"
			sso_role: "Administrator"
			name:     "chamber-5"
			imported: "yes"
		}
		"6": {
			id:       "493089153027"
			email:    "chamber-6@defn.us"
			sso_role: "Administrator"
			name:     "chamber-6"
			imported: "yes"
		}
		"7": {
			id:       "837425503386"
			email:    "chamber-7@defn.us"
			sso_role: "Administrator"
			name:     "chamber-7"
			imported: "yes"
		}
		"8": {
			id:       "773314335856"
			email:    "chamber-8@defn.us"
			sso_role: "Administrator"
			name:     "chamber-8"
			imported: "yes"
		}
		"9": {
			id:       "950940975070"
			email:    "chamber-9@defn.us"
			sso_role: "Administrator"
			name:     "chamber-9"
			imported: "yes"
		}
		a: {
			id:       "503577294851"
			email:    "defn-a@imma.io"
			sso_role: "Administrator"
			name:     "defn-a"
			imported: "yes"
		}
		b: {
			id:       "310940910494"
			email:    "imma-admin1@imma.io"
			sso_role: "Administrator"
			name:     "defn-b"
			imported: "yes"
		}
		c: {
			id:       "047633732615"
			email:    "dev-eng1@imma.io"
			sso_role: "Administrator"
			name:     "defn-c"
			imported: "yes"
		}
		d: {
			id:       "699441347021"
			email:    "box-adm1@imma.io"
			sso_role: "Administrator"
			name:     "defn-d"
			imported: "yes"
		}
		e: {
			id:       "171831323337"
			email:    "stg-eng1@imma.io"
			sso_role: "Administrator"
			name:     "defn-e"
			imported: "yes"
		}
		f: {
			id:       "842022523232"
			email:    "usr-admin1@imma.io"
			sso_role: "Administrator"
			name:     "defn-f"
			imported: "yes"
		}
		g: {
			id:       "023867963778"
			email:    "usr-adm1@imma.io"
			sso_role: "Administrator"
			name:     "defn-g"
			imported: "yes"
		}
		h: {
			id:       "371020107387"
			email:    "usr-eng1@imma.io"
			sso_role: "Administrator"
			name:     "defn-h"
			imported: "yes"
		}
		i: {
			id:       "290132238209"
			email:    "aws-admin1@defn.us"
			sso_role: "Administrator"
			name:     "defn-i"
			imported: "yes"
		}
		j: {
			id:       "738433022197"
			email:    "aws-development1@defn.us"
			sso_role: "Administrator"
			name:     "defn-j"
			imported: "yes"
		}
		l: {
			id:       "991300382347"
			email:    "aws-staging1@defn.us"
			sso_role: "Administrator"
			name:     "defn-l"
			imported: "yes"
		}
		m: {
			id:       "684895750259"
			email:    "defn-m@defn.us"
			sso_role: "Administrator"
			name:     "defn-m"
			imported: "yes"
		}
		n: {
			id:       "705881812506"
			email:    "defn-n@defn.us"
			sso_role: "Administrator"
			name:     "defn-n"
			imported: "yes"
		}
		o: {
			id:       "307136835824"
			email:    "defn-o@defn.us"
			sso_role: "Administrator"
			name:     "defn-o"
			imported: "yes"
		}
		p: {
			id:       "706168331526"
			email:    "defn-p@defn.us"
			sso_role: "Administrator"
			name:     "defn-p"
			imported: "yes"
		}
		q: {
			id:       "217047480856"
			email:    "aws-dev@defn.us"
			sso_role: "Administrator"
			name:     "defn-dev"
			imported: "yes"
		}
		r: {
			id:       "416221726155"
			email:    "defn-r@imma.io"
			sso_role: "Administrator"
			name:     "defn-r"
			imported: "yes"
		}
		s: {
			id:       "840650118369"
			email:    "defn-s@imma.io"
			sso_role: "Administrator"
			name:     "defn-s"
			imported: "yes"
		}
		t: {
			id:       "490895200523"
			email:    "defn-t@imma.io"
			sso_role: "Administrator"
			name:     "defn-t"
			imported: "yes"
		}
		u: {
			id:       "467995590869"
			email:    "aws-qa@defn.us"
			sso_role: "Administrator"
			name:     "defn-qa"
			imported: "yes"
		}
		v: {
			id:       "979368042862"
			email:    "defn-v@imma.io"
			sso_role: "Administrator"
			name:     "defn-v"
			imported: "yes"
		}
		w: {
			id:       "313387692116"
			email:    "defn-w@imma.io"
			sso_role: "Administrator"
			name:     "defn-w"
			imported: "yes"
		}
		x: {
			id:       "834936839208"
			email:    "aws-stage@defn.us"
			sso_role: "Administrator"
			name:     "defn-stage"
			imported: "yes"
		}
		y: {
			id:       "153556747817"
			email:    "aws-prod@defn.us"
			sso_role: "Administrator"
			name:     "defn-prod"
			imported: "yes"
		}
		z: {
			id:       "037804009879"
			email:    "aws-hub@defn.us"
			sso_role: "Administrator"
			name:     "defn-hub"
			imported: "yes"
		}
	}
	circus: account: {
		org: {
			id:       "036139182623"
			email:    "aws-circus@defn.us"
			sso_role: "Administrator"
			name:     "circus"
			imported: "yes"
		}
		net: {
			id:       "002516226222"
			email:    "aws-circus-transit@defn.sh"
			sso_role: "Administrator"
			t:        "transit"
			name:     "transit"
			imported: "yes"
		}
		log: {
			id:       "707476523482"
			email:    "aws-circus-audit@defn.sh"
			sso_role: "Administrator"
			t:        "audit"
			name:     "audit"
			imported: "yes"
		}
		lib: {
			id:       "497790518354"
			email:    "aws-circus-govcloud@defn.sh"
			sso_role: "Administrator"
			t:        "govcloud"
			name:     "govcloud"
			imported: "yes"
		}
		ops: {
			id:       "415618116579"
			email:    "aws-circus-ops@defn.sh"
			sso_role: "Administrator"
			name:     "ops"
			imported: "yes"
		}
	}
	coil: account: {
		org: {
			id:       "138291560003"
			email:    "aws-coil@defn.us"
			sso_role: "Administrator"
			name:     "coil"
		}
		net: {
			id:       "278790191486"
			email:    "aws-coil+net@defn.us"
			sso_role: "Administrator"
			name:     "net"
		}
		lib: {
			id:       "160764896647"
			email:    "aws-coil+lib@defn.us"
			sso_role: "Administrator"
			name:     "lib"
		}
		hub: {
			id:       "453991412409"
			email:    "aws-coil+hub@defn.us"
			sso_role: "Administrator"
			name:     "hub"
		}
	}
	curl: account: {
		org: {
			id:       "424535767618"
			email:    "aws-curl@defn.us"
			sso_role: "Administrator"
			name:     "curl"
		}
		net: {
			id:       "101142583332"
			email:    "aws-curl+net@defn.us"
			sso_role: "Administrator"
			name:     "net"
		}
		lib: {
			id:       "298406631539"
			email:    "aws-curl+lib@defn.us"
			sso_role: "Administrator"
			name:     "lib"
		}
		hub: {
			id:       "804430872255"
			email:    "aws-curl+hub@defn.us"
			sso_role: "Administrator"
			name:     "hub"
		}
	}
	defn: account: org: {
		id:       "510430971399"
		email:    "iam+bootstrap@defn.sh"
		sso_role: "Administrator"
		name:     "defn"
	}
	fogg: account: {
		org: {
			id:       "328216504962"
			email:    "spiral@defn.sh"
			sso_role: "Administrator"
			name:     "fogg"
			imported: "yes"
		}
		net: {
			id:       "060659916753"
			email:    "fogg-asset@defn.sh"
			sso_role: "Administrator"
			t:        "asset"
			name:     "asset"
			prefix:   "fogg-"
			imported: "yes"
		}
		log: {
			id:       "844609041254"
			email:    "fogg-circus@defn.sh"
			sso_role: "Administrator"
			t:        "circus"
			name:     "circus"
			prefix:   "fogg-"
			imported: "yes"
		}
		lib: {
			id:       "624713464251"
			email:    "fogg-data@defn.sh"
			sso_role: "Administrator"
			t:        "data"
			name:     "data"
			prefix:   "fogg-"
			imported: "yes"
		}
		ops: {
			id:       "318746665903"
			email:    "fogg-gateway@defn.sh"
			sso_role: "Administrator"
			t:        "gateway"
			name:     "gateway"
			prefix:   "fogg-"
			imported: "yes"
		}
		ci: {
			id:       "812459563189"
			email:    "fogg-home@defn.sh"
			sso_role: "Administrator"
			t:        "home"
			name:     "home"
			prefix:   "fogg-"
			imported: "yes"
		}
		hub: {
			id:       "337248635000"
			email:    "fogg-hub@defn.sh"
			sso_role: "Administrator"
			name:     "hub"
			prefix:   "fogg-"
			imported: "yes"
		}
		prod: {
			id:       "565963418226"
			email:    "fogg-postx@defn.sh"
			sso_role: "Administrator"
			t:        "postx"
			name:     "postx"
			prefix:   "fogg-"
			imported: "yes"
		}
		dev: {
			id:       "442766271046"
			email:    "fogg-sandbox@defn.sh"
			sso_role: "Administrator"
			t:        "sandbox"
			name:     "sandbox"
			prefix:   "fogg-"
			imported: "yes"
		}
		pub: {
			id:       "372333168887"
			email:    "fogg-security@defn.sh"
			sso_role: "Administrator"
			t:        "security"
			name:     "security"
			prefix:   "fogg-"
			imported: "yes"
		}
	}
	gyre: account: {
		org: {
			id:       "065163301604"
			email:    "aws-gyre@defn.us"
			sso_role: "Administrator"
			name:     "gyre"
		}
		ops: {
			id:       "319951235442"
			email:    "aws-gyre+ops@defn.us"
			sso_role: "Administrator"
			name:     "ops"
		}
	}
	helix: account: {
		org: {
			id:       "816178966829"
			email:    "aws-helix@defn.sh"
			sso_role: "Administrator"
			name:     "helix"
		}
		log: {
			id:       "664427926343"
			email:    "aws-helix+log@defn.sh"
			sso_role: "Administrator"
			name:     "log"
		}
		net: {
			id:       "504722108514"
			email:    "aws-helix+net@defn.sh"
			sso_role: "Administrator"
			name:     "net"
		}
		lib: {
			id:       "377857698578"
			email:    "aws-helix+lib@defn.sh"
			sso_role: "Administrator"
			name:     "lib"
		}
		ops: {
			id:       "368812692254"
			email:    "aws-helix+ops@defn.sh"
			sso_role: "Administrator"
			name:     "ops"
		}
		ci: {
			id:       "018520313738"
			email:    "aws-helix+sec@defn.sh"
			sso_role: "Administrator"
			t:        "sec"
			name:     "sec"
		}
		pub: {
			id:       "536806623881"
			email:    "aws-helix+pub@defn.sh"
			sso_role: "Administrator"
			name:     "pub"
		}
		hub: {
			id:       "436043820387"
			email:    "aws-helix+hub@defn.sh"
			sso_role: "Administrator"
			name:     "hub"
		}
		dev: {
			id:       "843784871878"
			email:    "aws-helix+dev@defn.sh"
			sso_role: "Administrator"
			name:     "dev"
		}
		prod: {
			id:       "724643698007"
			email:    "aws-helix+dmz@defn.sh"
			sso_role: "Administrator"
			t:        "dmz"
			name:     "dmz"
		}
	}
	imma: account: {
		org: {
			id:       "548373030883"
			email:    "aws-imma@defn.us"
			sso_role: "Administrator"
			name:     "imma"
			imported: "yes"
		}
		net: {
			id:       "246197522468"
			email:    "imma-defn@defn.us"
			sso_role: "Administrator"
			t:        "defn"
			name:     "imma-defn"
			imported: "yes"
		}
		log: {
			id:       "289716781198"
			email:    "imma-dgwyn@defn.us"
			sso_role: "Administrator"
			t:        "dgwyn"
			name:     "imma-dgwyn"
			imported: "yes"
		}
		lib: {
			id:       "516851121506"
			email:    "imma-tolan@defn.us"
			sso_role: "Administrator"
			t:        "tolan"
			name:     "imma-tolan"
			imported: "yes"
		}
		dev: {
			id:       "445584037541"
			email:    "imma-dev@imma.io"
			sso_role: "Administrator"
			name:     "imma-dev"
			imported: "yes"
		}
		pub: {
			id:       "766142996227"
			email:    "imma-prod@imma.io"
			sso_role: "Administrator"
			t:        "prod"
			name:     "imma-prod"
			imported: "yes"
		}
	}
	immanent: account: {
		org: {
			id:       "545070380609"
			email:    "aws-immanent@defn.us"
			sso_role: "Administrator"
			name:     "immanent"
			imported: "yes"
		}
		patterner: {
			id:       "143220204648"
			email:    "immanent-patterner@defn.us"
			sso_role: "Administrator"
			name:     "immanent-patterner"
			t:        "patterner"
			imported: "yes"
		}
		windkey: {
			id:       "095764861781"
			email:    "immanent-windkey@defn.us"
			sso_role: "Administrator"
			name:     "immanent-windkey"
			t:        "windkey"
			imported: "yes"
		}
		summoner: {
			id:       "397411277587"
			email:    "immanent-summoner@defn.us"
			sso_role: "Administrator"
			name:     "immanent-summoner"
			t:        "summoner"
			imported: "yes"
		}
		herbal: {
			id:       "165452499696"
			email:    "immanent-herbal@defn.us"
			sso_role: "Administrator"
			name:     "immanent-herbal"
			t:        "herbal"
			imported: "yes"
		}
		namer: {
			id:       "856549015893"
			email:    "immanent-namer@defn.us"
			sso_role: "Administrator"
			name:     "immanent-namer"
			t:        "namer"
			imported: "yes"
		}
		ged: {
			id:       "640792184178"
			email:    "immanent-ged@defn.us"
			sso_role: "Administrator"
			name:     "immanent-ged"
			t:        "ged"
			imported: "yes"
		}
		roke: {
			id:       "892560628624"
			email:    "immanent-roke@defn.us"
			sso_role: "Administrator"
			name:     "immanent-roke"
			t:        "roke"
			imported: "yes"
		}
		chanter: {
			id:       "071244154667"
			email:    "immanent-chanter@defn.us"
			sso_role: "Administrator"
			name:     "immanent-chanter"
			t:        "chanter"
			imported: "yes"
		}
		changer: {
			id:       "003884504807"
			email:    "immanent-changer@defn.us"
			sso_role: "Administrator"
			name:     "immanent-changer"
			t:        "changer"
			imported: "yes"
		}
		hand: {
			id:       "826250190242"
			email:    "immanent-hand@defn.us"
			sso_role: "Administrator"
			name:     "immanent-hand"
			t:        "hand"
			imported: "yes"
		}
		doorkeeper: {
			id:       "013267321144"
			email:    "immanent-doorkeeper@defn.us"
			sso_role: "Administrator"
			name:     "immanent-doorkeeper"
			t:        "doorkeeper"
			imported: "yes"
		}
	}
	jianghu: account: {
		org: {
			id:       "657613322961"
			email:    "aws-jianghu@defn.us"
			sso_role: "Administrator"
			name:     "jianghu"
			imported: "yes"
		}
		net: {
			id:       "025636091251"
			email:    "tahoe@defn.us"
			sso_role: "Administrator"
			t:        "tahoe"
			name:     "tahoe"
			imported: "yes"
		}
		log: {
			id:       "298431841138"
			email:    "klamath@defn.us"
			sso_role: "Administrator"
			t:        "klamath"
			name:     "klamath"
			imported: "yes"
		}
	}
	spiral: account: {
		org: {
			id:       "232091571197"
			email:    "aws-spiral@defn.us"
			sso_role: "Administrator"
			name:     "spiral"
		}
		log: {
			id:       "442333715734"
			email:    "aws-spiral+log@defn.us"
			sso_role: "Administrator"
			name:     "log"
		}
		net: {
			id:       "057533398557"
			email:    "aws-spiral+net@defn.us"
			sso_role: "Administrator"
			name:     "net"
		}
		lib: {
			id:       "073874947996"
			email:    "aws-spiral+lib@defn.us"
			sso_role: "Administrator"
			name:     "lib"
		}
		ops: {
			id:       "601164058091"
			email:    "aws-spiral+ops@defn.us"
			sso_role: "Administrator"
			name:     "ops"
		}
		ci: {
			id:       "371657257885"
			email:    "aws-spiral+pub@defn.us"
			sso_role: "Administrator"
			t:        "pub"
			name:     "pub"
		}
		pub: {
			id:       "130046154300"
			email:    "aws-spiral+dmz@defn.us"
			sso_role: "Administrator"
			t:        "dmz"
			name:     "dmz"
		}
		hub: {
			id:       "216704421225"
			email:    "aws-spiral+hub@defn.us"
			sso_role: "Administrator"
			name:     "hub"
		}
		dev: {
			id:       "308726031860"
			email:    "aws-spiral+dev@defn.us"
			sso_role: "Administrator"
			name:     "dev"
		}
		prod: {
			id:       "398258703387"
			email:    "aws-spiral+sec@defn.us"
			sso_role: "Administrator"
			t:        "sec"
			name:     "sec"
		}
	}
	vault: account: {
		org: {
			id:       "475528707847"
			email:    "aws-vault@defn.us"
			sso_role: "Administrator"
			name:     "vault"
			imported: "yes"
		}
		log: {
			id:       "749185891195"
			email:    "aws-vault-audit@defn.sh"
			sso_role: "Administrator"
			t:        "audit"
			name:     "audit"
			imported: "yes"
		}
		net: {
			id:       "915207860232"
			email:    "aws-vault-transit@defn.sh"
			sso_role: "Administrator"
			t:        "transit"
			name:     "transit"
			imported: "yes"
		}
		lib: {
			id:       "066356637485"
			email:    "aws-vault-library@defn.sh"
			sso_role: "Administrator"
			t:        "library"
			name:     "library"
			imported: "yes"
		}
		ops: {
			id:       "188066400611"
			email:    "aws-vault-ops@defn.sh"
			sso_role: "Administrator"
			name:     "ops"
			imported: "yes"
		}
		ci: {
			id:       "313228123503"
			email:    "aws-vault-vault0@defn.sh"
			sso_role: "Administrator"
			t:        "vault0"
			name:     "vault0"
			imported: "yes"
		}
		pub: {
			id:       "851162413429"
			email:    "aws-vault-pub@defn.sh"
			sso_role: "Administrator"
			name:     "pub"
			imported: "yes"
		}
		hub: {
			id:       "539099112425"
			email:    "aws-vault-hub@defn.sh"
			sso_role: "Administrator"
			name:     "hub"
			imported: "yes"
		}
		dev: {
			id:       "497393606242"
			email:    "aws-vault-dev@defn.sh"
			sso_role: "Administrator"
			name:     "dev"
			imported: "yes"
		}
		prod: {
			id:       "040769490632"
			email:    "aws-vault-vault1@defn.sh"
			sso_role: "Administrator"
			t:        "vault1"
			name:     "vault1"
			imported: "yes"
		}
	}
	whoa: account: {
		org: {
			id:       "389772512117"
			email:    "aws-whoa@defn.us"
			sso_role: "Administrator"
			name:     "whoa"
			imported: "yes"
		}
		net: {
			id:       "464075062390"
			email:    "whoa-secrets@imma.io"
			sso_role: "Administrator"
			t:        "secrets"
			name:     "secrets"
			imported: "yes"
			prefix:   "whoa-"
		}
		hub: {
			id:       "462478722501"
			email:    "whoa-hub@imma.io"
			sso_role: "Administrator"
			name:     "hub"
			imported: "yes"
			prefix:   "whoa-"
		}
		dev: {
			id:       "439761234835"
			email:    "whoa-dev@imma.io"
			sso_role: "Administrator"
			name:     "dev"
			t:        "dev"
			imported: "yes"
			prefix:   "whoa-"
		}
		pub: {
			id:       "204827926367"
			email:    "whoa-prod@imma.io"
			sso_role: "Administrator"
			t:        "prod"
			name:     "prod"
			imported: "yes"
			prefix:   "whoa-"
		}
	}
}
