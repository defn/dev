package aws

import (
	"github.com/defn/dev/m/tf"
)

org: [ORG=string]: {
	org: ORG
	region: tf.organization[ORG].region
}

org: {
	defn: {
		url:    "https://defn.awsapps.com/start"
	}
	coil: {
		url:    "https://d-90674c3cfd.awsapps.com/start"
	}
	curl: {
		url:    "https://d-926760a859.awsapps.com/start"
	}
	gyre: {
		url:    "https://d-9a6716e54a.awsapps.com/start"
	}
	helix: {
		url:    "https://d-9a6716ffd1.awsapps.com/start"
	}
	spiral: {
		url:    "https://d-926760b322.awsapps.com/start"
	}
	vault: {
		url:    "https://d-9a672a0e52.awsapps.com/start"
	}
	circus: {
		url:    "https://d-92670c4790.awsapps.com/start"
	}
	chamber: {
		url:    "https://chamber-0.awsapps.com/start"
	}
	whoa: {
		url:    "https://whoa-0.awsapps.com/start"
	}
	imma: {
		url:    "https://imma-0.awsapps.com/start"
	}
	immanent: {
		url:    "https://immanent-0.awsapps.com/start"
	}
	jianghu: {
		url:    "https://jianghu-0.awsapps.com/start"
	}
	fogg: {
		url:    "https://fogg-0.awsapps.com/start"
	}
}
