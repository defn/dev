package intention

aws: "org": [string]: close({
	org:        string
	sso_region: string
	sso_url:    =~"https://[a-z0-9-]+.awsapps.com/start"
	"account": [string]: close({
		account:    string
		org:        string
		id!:        =~"^[0-9]+$"
		email!:     string
		name:       string
		sso_role:   string
		aws_config: string

		aws_config: """
[profile \(org)-\(account)]
sso_account_id=\(id)
sso_start_url=\(sso_url)
sso_role_name=\(sso_role)
sso_region=\(sso_region)
"""
	})
})
