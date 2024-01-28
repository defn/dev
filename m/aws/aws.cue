package aws

import (
	"github.com/defn/dev/m/tf"
)

org: [ORG=string]: {
	region:   tf.input.organization[ORG].region
}
org: [ORG=string]: account: [ACCOUNT=string]: {
	org:      ORG
	account:  ACCOUNT
	id:       string | *"TODO"
	email:    string | *"TODO"
	sso_role: string | *"Administrator"
}

org: {
	for name, org in tf.input.organization {
		(name): account: {
			for acc in org.accounts {
				(acc.profile): {
					email: acc.email
				}
			}
		}
	}

}

org: {
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
