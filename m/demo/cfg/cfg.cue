package cfg

import (
	"github.com/defn/dev/m/demo/third_party/defn-dev/m/command/infra"
)

input: infra.#AwsProps & {
	backend: {
		lock:    "demonstrate-terraform-remote-state-lock"
		bucket:  "demonstrate-terraform-remote-state"
		profile: "demo-ops-sso"
		region:  "us-west-2"
	}

	organization: {
		demo: {
			region: "us-west-2"

			url: "https://demonstrate.awsapps.com/start"

			ops_org_name:     "demo"
			ops_account_name: "ops"
			ops_account_id:   "992382597334"

			accounts: [{
				name:     "demo"
				profile:  "org"
				email:    "iam+demo-org@defn.sh"
				imported: "yes"
				region:   "us-west-2"
				id:       "992382597334"
			}, {
				name:     "ops"
				email:    "iam+demo-ops@defn.sh"
				imported: "yes"
				region:   "us-west-2"
				id:       "339712953662"
			}, {
				name:   "net"
				email:  "iam+demo-net@defn.sh"
				region: "us-west-2"
				id:     "851725656107"
			}, {
				name:   "dev"
				email:  "iam+demo-dev@defn.sh"
				region: "us-west-2"
				id:     "730335323345"
			}]
		}
	}
}
