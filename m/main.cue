package main

aws_admins: []

full_accounts: ["ops", "net", "lib", "hub", "log", "sec", "pub", "dev", "dmz"]
env_accounts: ["net", "lib", "hub"]
ops_accounts: ["ops"]
no_accounts: []

input: organizations: [N=string]: {
	name:     N
	prefix:   string | *"aws-"
	domain:   string | *"defn.us"
	admins:   [... {...}] | *aws_admins
	accounts: [...string] | *no_accounts
}
