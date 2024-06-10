package aws

import (
	tf "github.com/defn/dev/m/infra"
)

org: {
	[ORG=string]: {
		region: tf.input.organization[ORG].region

		account: [ACCOUNT=string]: {
			org:      ORG
			account:  ACCOUNT
			id:       string
			email:    string
			sso_role: string | *"Administrator"
		}
	}

	for name, org in tf.input.organization {
		(name): account: {
			for acc in org.accounts {
				(acc.profile): {
					email: acc.email
					id:    tf.lookup[name].accounts[acc.profile].id
				}
			}
		}
	}

	tf.lookup
}
