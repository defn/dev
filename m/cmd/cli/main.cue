package main

aws_admins: [{
	name:  "defn"
	email: "iam@defn.sh"
}]

full_accounts: ["ops", "net", "lib", "hub", "log", "sec", "pub", "dev", "dmz"]
env_accounts: ["ops", "net", "lib", "hub"]
ops_accounts: ["ops"]
no_accounts: []

input: {
	terraform: {
		organization: "defn"
		workspace:    "workspaces"
	}

	organizations: [N=string]: {
		name:     N
		prefix:   string | *"aws-"
		domain:   string | *"defn.us"
		admins:   [... {...}] | *aws_admins
		accounts: [...string] | *no_accounts
	}

	organizations: {
		demo: {
			region:   "us-east-2"
			accounts: ops_accounts
		}
	}
}
