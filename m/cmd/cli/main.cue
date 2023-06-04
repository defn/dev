package m

aws_admins: [{
	name:  "defn"
	email: "iam@defn.sh"
}]

input: organizations: {
	demo: {
		region:   "us-east-2"
		accounts: ops_accounts
	}
}
