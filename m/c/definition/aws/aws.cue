package aws

org: [ORG=string]: close({
	region: "us-west-2" | "us-east-2" | "us-east-1"
	url:    =~"https://[a-z0-9-]+.awsapps.com/start"
	account: [ACCOUNT=string]: close({
		account:  ACCOUNT
		org:      ORG
		id!:      =~"^[0-9]+$"
		email!:   string
		sso_role: string | *"Administrator"

		name: string | *ACCOUNT
		if ACCOUNT == "org" {
			name: ORG
		}
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
	// Large multi-environment organization (30 accounts)
	chamber: account: {
		org: {
			id:    "730917619329"
			email: "aws-chamber@defn.us"
		}
		"1": {
			id:    "741346472057"
			email: "aws-cd@defn.us"
			name:  "defn-cd"
		}
		"2": {
			id:    "447993872368"
			email: "aws-ci@defn.us"
			name:  "defn-ci"
		}
		"3": {
			id:    "463050069968"
			email: "aws-users@defn.us"
			name:  "defn-security"
		}
		"4": {
			id:    "368890376620"
			email: "chamber-4@defn.us"
			name:  "chamber-4"
		}
		"5": {
			id:    "200733412967"
			email: "chamber-5@defn.us"
			name:  "chamber-5"
		}
		"6": {
			id:    "493089153027"
			email: "chamber-6@defn.us"
			name:  "chamber-6"
		}
		"7": {
			id:    "837425503386"
			email: "chamber-7@defn.us"
			name:  "chamber-7"
		}
		"8": {
			id:    "773314335856"
			email: "chamber-8@defn.us"
			name:  "chamber-8"
		}
		"9": {
			id:    "950940975070"
			email: "chamber-9@defn.us"
			name:  "chamber-9"
		}
		a: {
			id:    "503577294851"
			email: "defn-a@imma.io"
			name:  "defn-a"
		}
		b: {
			id:    "310940910494"
			email: "imma-admin1@imma.io"
			name:  "defn-b"
		}
		c: {
			id:    "047633732615"
			email: "dev-eng1@imma.io"
			name:  "defn-c"
		}
		d: {
			id:    "699441347021"
			email: "box-adm1@imma.io"
			name:  "defn-d"
		}
		e: {
			id:    "171831323337"
			email: "stg-eng1@imma.io"
			name:  "defn-e"
		}
		f: {
			id:    "842022523232"
			email: "usr-admin1@imma.io"
			name:  "defn-f"
		}
		g: {
			id:    "023867963778"
			email: "usr-adm1@imma.io"
			name:  "defn-g"
		}
		h: {
			id:    "371020107387"
			email: "usr-eng1@imma.io"
			name:  "defn-h"
		}
		i: {
			id:    "290132238209"
			email: "aws-admin1@defn.us"
			name:  "defn-i"
		}
		j: {
			id:    "738433022197"
			email: "aws-development1@defn.us"
			name:  "defn-j"
		}
		l: {
			id:    "991300382347"
			email: "aws-staging1@defn.us"
			name:  "defn-l"
		}
		m: {
			id:    "684895750259"
			email: "defn-m@defn.us"
			name:  "defn-m"
		}
		n: {
			id:    "705881812506"
			email: "defn-n@defn.us"
			name:  "defn-n"
		}
		o: {
			id:    "307136835824"
			email: "defn-o@defn.us"
			name:  "defn-o"
		}
		p: {
			id:    "706168331526"
			email: "defn-p@defn.us"
			name:  "defn-p"
		}
		q: {
			id:    "217047480856"
			email: "aws-dev@defn.us"
			name:  "defn-dev"
		}
		r: {
			id:    "416221726155"
			email: "defn-r@imma.io"
			name:  "defn-r"
		}
		s: {
			id:    "840650118369"
			email: "defn-s@imma.io"
			name:  "defn-s"
		}
		t: {
			id:    "490895200523"
			email: "defn-t@imma.io"
			name:  "defn-t"
		}
		u: {
			id:    "467995590869"
			email: "aws-qa@defn.us"
			name:  "defn-qa"
		}
		v: {
			id:    "979368042862"
			email: "defn-v@imma.io"
			name:  "defn-v"
		}
		w: {
			id:    "313387692116"
			email: "defn-w@imma.io"
			name:  "defn-w"
		}
		x: {
			id:    "834936839208"
			email: "aws-stage@defn.us"
			name:  "defn-stage"
		}
		y: {
			id:    "153556747817"
			email: "aws-prod@defn.us"
			name:  "defn-prod"
		}
		z: {
			id:    "037804009879"
			email: "aws-hub@defn.us"
			name:  "defn-hub"
		}
	}
	// Infrastructure subset: org, ops, lib, log, net
	circus: account: {
		org: {
			id:    "036139182623"
			email: "aws-circus@defn.us"
		}
		lib: {
			id:    "497790518354"
			email: "aws-circus-govcloud@defn.sh"
			name:  "govcloud"
		}
		log: {
			id:    "707476523482"
			email: "aws-circus-audit@defn.sh"
			name:  "audit"
		}
		net: {
			id:    "002516226222"
			email: "aws-circus-transit@defn.sh"
			name:  "transit"
		}
		ops: {
			id:    "415618116579"
			email: "aws-circus-ops@defn.sh"
		}
	}
	// Infrastructure subset: org, hub, lib, net
	coil: account: {
		org: {
			id:    "138291560003"
			email: "aws-coil@defn.us"
		}
		hub: {
			id:    "453991412409"
			email: "aws-coil+hub@defn.us"
		}
		lib: {
			id:    "160764896647"
			email: "aws-coil+lib@defn.us"
		}
		net: {
			id:    "278790191486"
			email: "aws-coil+net@defn.us"
		}
	}
	// Infrastructure subset: org, hub, lib, net
	curl: account: {
		org: {
			id:    "424535767618"
			email: "aws-curl@defn.us"
		}
		hub: {
			id:    "804430872255"
			email: "aws-curl+hub@defn.us"
		}
		lib: {
			id:    "298406631539"
			email: "aws-curl+lib@defn.us"
		}
		net: {
			id:    "101142583332"
			email: "aws-curl+net@defn.us"
		}
	}
	// Bootstrap IAM account only
	defn: account: org: {
		id:    "510430971399"
		email: "iam+bootstrap@defn.sh"
	}

	// Complete 10-account structure: org, ops, ci, dev, hub, lib, log, net, prod, pub
	fogg: account: {
		org: {
			id:    "328216504962"
			email: "spiral@defn.sh"
		}
		ci: {
			id:    "812459563189"
			email: "fogg-home@defn.sh"
			name:  "home"
		}
		dev: {
			id:    "442766271046"
			email: "fogg-sandbox@defn.sh"
			name:  "sandbox"
		}
		hub: {
			id:    "337248635000"
			email: "fogg-hub@defn.sh"
		}
		lib: {
			id:    "624713464251"
			email: "fogg-data@defn.sh"
			name:  "data"
		}
		log: {
			id:    "844609041254"
			email: "fogg-circus@defn.sh"
			name:  "circus"
		}
		net: {
			id:    "060659916753"
			email: "fogg-asset@defn.sh"
			name:  "asset"
		}
		ops: {
			id:    "318746665903"
			email: "fogg-gateway@defn.sh"
			name:  "gateway"
		}
		prod: {
			id:    "565963418226"
			email: "fogg-postx@defn.sh"
			name:  "postx"
		}
		pub: {
			id:    "372333168887"
			email: "fogg-security@defn.sh"
			name:  "security"
		}
	}
	// Infrastructure subset: org, ops
	gyre: account: {
		org: {
			id:    "065163301604"
			email: "aws-gyre@defn.us"
		}
		ops: {
			id:    "319951235442"
			email: "aws-gyre+ops@defn.us"
		}
	}

	// Complete 10-account structure: org, ops, ci, dev, hub, lib, log, net, prod, pub
	helix: account: {
		org: {
			id:    "816178966829"
			email: "aws-helix@defn.sh"
		}
		ci: {
			id:    "018520313738"
			email: "aws-helix+sec@defn.sh"
			name:  "sec"
		}
		dev: {
			id:    "843784871878"
			email: "aws-helix+dev@defn.sh"
		}
		hub: {
			id:    "436043820387"
			email: "aws-helix+hub@defn.sh"
		}
		lib: {
			id:    "377857698578"
			email: "aws-helix+lib@defn.sh"
		}
		log: {
			id:    "664427926343"
			email: "aws-helix+log@defn.sh"
		}
		net: {
			id:    "504722108514"
			email: "aws-helix+net@defn.sh"
		}
		ops: {
			id:    "368812692254"
			email: "aws-helix+ops@defn.sh"
		}
		prod: {
			id:    "724643698007"
			email: "aws-helix+dmz@defn.sh"
			name:  "dmz"
		}
		pub: {
			id:    "536806623881"
			email: "aws-helix+pub@defn.sh"
		}
	}
	// Miscellaneous
	imma: account: {
		org: {
			id:    "548373030883"
			email: "aws-imma@defn.us"
		}
		dev: {
			id:    "445584037541"
			email: "imma-dev@imma.io"
			name:  "imma-dev"
		}
		lib: {
			id:    "516851121506"
			email: "imma-tolan@defn.us"
			name:  "imma-tolan"
		}
		log: {
			id:    "289716781198"
			email: "imma-dgwyn@defn.us"
			name:  "imma-dgwyn"
		}
		net: {
			id:    "246197522468"
			email: "imma-defn@defn.us"
			name:  "imma-defn"
		}
		pub: {
			id:    "766142996227"
			email: "imma-prod@imma.io"
			name:  "imma-prod"
		}
	}
	// Extended multi-account structure with Earthsea-themed account names
	immanent: account: {
		org: {
			id:    "545070380609"
			email: "aws-immanent@defn.us"
		}
		changer: {
			id:    "003884504807"
			email: "immanent-changer@defn.us"
			name:  "immanent-changer"
		}
		chanter: {
			id:    "071244154667"
			email: "immanent-chanter@defn.us"
			name:  "immanent-chanter"
		}
		doorkeeper: {
			id:    "013267321144"
			email: "immanent-doorkeeper@defn.us"
			name:  "immanent-doorkeeper"
		}
		ged: {
			id:    "640792184178"
			email: "immanent-ged@defn.us"
			name:  "immanent-ged"
		}
		hand: {
			id:    "826250190242"
			email: "immanent-hand@defn.us"
			name:  "immanent-hand"
		}
		herbal: {
			id:    "165452499696"
			email: "immanent-herbal@defn.us"
			name:  "immanent-herbal"
		}
		namer: {
			id:    "856549015893"
			email: "immanent-namer@defn.us"
			name:  "immanent-namer"
		}
		patterner: {
			id:    "143220204648"
			email: "immanent-patterner@defn.us"
			name:  "immanent-patterner"
		}
		roke: {
			id:    "892560628624"
			email: "immanent-roke@defn.us"
			name:  "immanent-roke"
		}
		summoner: {
			id:    "397411277587"
			email: "immanent-summoner@defn.us"
			name:  "immanent-summoner"
		}
		windkey: {
			id:    "095764861781"
			email: "immanent-windkey@defn.us"
			name:  "immanent-windkey"
		}
	}
	// Infrastructure subset: org, log, net
	jianghu: account: {
		org: {
			id:    "657613322961"
			email: "aws-jianghu@defn.us"
		}
		log: {
			id:    "298431841138"
			email: "klamath@defn.us"
			name:  "klamath"
		}
		net: {
			id:    "025636091251"
			email: "tahoe@defn.us"
			name:  "tahoe"
		}
	}

	// Complete 10-account structure: org, ops, ci, dev, hub, lib, log, net, prod, pub
	spiral: account: {
		org: {
			id:    "232091571197"
			email: "aws-spiral@defn.us"
		}
		ci: {
			id:    "371657257885"
			email: "aws-spiral+pub@defn.us"
			name:  "pub"
		}
		dev: {
			id:    "308726031860"
			email: "aws-spiral+dev@defn.us"
		}
		hub: {
			id:    "216704421225"
			email: "aws-spiral+hub@defn.us"
		}
		lib: {
			id:    "073874947996"
			email: "aws-spiral+lib@defn.us"
		}
		log: {
			id:    "442333715734"
			email: "aws-spiral+log@defn.us"
		}
		net: {
			id:    "057533398557"
			email: "aws-spiral+net@defn.us"
		}
		ops: {
			id:    "601164058091"
			email: "aws-spiral+ops@defn.us"
		}
		prod: {
			id:    "398258703387"
			email: "aws-spiral+sec@defn.us"
			name:  "sec"
		}
		pub: {
			id:    "130046154300"
			email: "aws-spiral+dmz@defn.us"
			name:  "dmz"
		}
	}
	// Complete 10-account structure: org, ops, ci, dev, hub, lib, log, net, prod, pub
	vault: account: {
		org: {
			id:    "475528707847"
			email: "aws-vault@defn.us"
		}
		ci: {
			id:    "313228123503"
			email: "aws-vault-vault0@defn.sh"
			name:  "vault0"
		}
		dev: {
			id:    "497393606242"
			email: "aws-vault-dev@defn.sh"
		}
		hub: {
			id:    "539099112425"
			email: "aws-vault-hub@defn.sh"
		}
		lib: {
			id:    "066356637485"
			email: "aws-vault-library@defn.sh"
			name:  "library"
		}
		log: {
			id:    "749185891195"
			email: "aws-vault-audit@defn.sh"
			name:  "audit"
		}
		net: {
			id:    "915207860232"
			email: "aws-vault-transit@defn.sh"
			name:  "transit"
		}
		ops: {
			id:    "188066400611"
			email: "aws-vault-ops@defn.sh"
		}
		prod: {
			id:    "040769490632"
			email: "aws-vault-vault1@defn.sh"
			name:  "vault1"
		}
		pub: {
			id:    "851162413429"
			email: "aws-vault-pub@defn.sh"
		}
	}
	// Miscellaneous
	whoa: account: {
		org: {
			id:    "389772512117"
			email: "aws-whoa@defn.us"
		}
		dev: {
			id:    "439761234835"
			email: "whoa-dev@imma.io"
		}
		hub: {
			id:    "462478722501"
			email: "whoa-hub@imma.io"
		}
		net: {
			id:    "464075062390"
			email: "whoa-secrets@imma.io"
			name:  "secrets"
		}
		pub: {
			id:    "204827926367"
			email: "whoa-prod@imma.io"
			name:  "prod"
		}
	}
}
