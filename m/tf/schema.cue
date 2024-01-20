package tf

import (
	"github.com/defn/dev/m/command/infra"
)

input: {
	backend: infra.#AwsBackend

	organization: [NAME=string]: infra.#AwsOrganization & {
		name:   NAME
		prefix: string | *"aws-"
		domain: string | *"defn.us"

		#no_admins: []
		admins: [... {...}] | *#no_admins

		#no_accounts: []
		accounts: [...string] | *#no_accounts
	}
}
