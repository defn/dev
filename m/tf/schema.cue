package tf

import (
	"github.com/defn/dev/m/command/infra"
)

input: {
	backend: infra.#AwsBackend

	organization: [NAME=string]: infra.#AwsOrganization & {
		name: NAME

		#no_admins: []
		admins: [... {...}] | *#no_admins

		#no_accounts: []
		accounts: [...infra.#AwsAccount] | *#no_accounts
	}
}
