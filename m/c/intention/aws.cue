@experiment(aliasv2)
@experiment(explicitopen)

package intention

aws: "org"~lookup: [string]~(ORG,_): close({
	org:        ORG
	sso_region: string
	sso_url:    =~"https://[a-z0-9-]+.awsapps.com/start"
	"account": [string]~(ACCOUNT,_): close({
		id!:        string
		account:    string
		org:        string
		name:       string
		email!:     string
		sso_role:   string
		aws_config: string

		id:      =~"^[0-9]+$"
		account: ACCOUNT
		org:     ORG
		name:    string | *ACCOUNT
		if ACCOUNT == "org" {
			name: ORG
		}
		sso_role: string | *"Administrator"

		mise_config: """
[env]
AWS_PROFILE = "\(org)-\(account)"
AWS_CONFIG_FILE = "/home/ubuntu/m/a/\(org)/\(account)/.aws/config"
"""

		aws_config: """
[profile \(org)-\(account)]
sso_account_id=\(id)
sso_role_name=\(sso_role)
sso_start_url=\(sso_url)
sso_region=\(sso_region)

[profile defn-org]
sso_account_id=\(lookup["defn"].account["org"].id)
sso_role_name=\(lookup["defn"].account["org"].sso_role)
sso_start_url=\(lookup["defn"].sso_url)
sso_region=\(lookup["defn"].sso_region)
"""
	})
})
