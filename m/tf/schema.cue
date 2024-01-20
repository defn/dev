package tf

import (
	"github.com/defn/dev/m/command/infra"
)

aws_admins: [...{...}] | *[]

full_accounts: ["ops", "net", "lib", "hub", "log", "sec", "pub", "dev", "dmz"]
env_accounts: ["net", "lib", "hub"]
ops_accounts: ["ops"]
no_accounts: []

input: {
	backend: infra.#AwsBackend

	organization: [NAME=string]: infra.#AwsOrganization & {
		name:   NAME
		prefix: string | *"aws-"
		domain: string | *"defn.us"
		admins: [... {...}] | *aws_admins
		accounts: [...string] | *no_accounts
	}
}
