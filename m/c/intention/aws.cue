@experiment(aliasv2)
@experiment(explicitopen)

package intention

import (
	"strings"
)

aws: "org"~lookup: [string]~(ORG,_): close({
	org:        ORG
	sso_region: string
	sso_url:    =~"https://[a-z0-9-]+.awsapps.com/start"

	"account": [string]~(ACCOUNT,_): close({
		id!:                         string
		account:                     string
		org:                         string
		name:                        string
		email!:                      string
		sso_role:                    string
		aws_config:                  string
		iam_user_access_to_billing?: string
		role_name?:                  string

		id:       =~"^[0-9]+$"
		account:  ACCOUNT
		org:      ORG
		name:     string | *"\(ORG)-\(ACCOUNT)"
		sso_role: string | *"Administrator"

		mise_config: """
# auto-generated: aws.cue mise_config
[env]
AWS_PROFILE = "\(org)-\(account)"
AWS_REGION = "\(sso_region)"
AWS_CONFIG_FILE = "/home/ubuntu/m/a/\(org)/\(account)/.aws/config"
"""

		aws_config_account: """
# auto-generated: aws.cue aws_config_account
[profile \(org)-\(account)]
sso_account_id=\(id)
sso_role_name=\(sso_role)
sso_start_url=\(sso_url)
sso_region=\(sso_region)
"""

		aws_config_bootstrap: """
# auto-generated: aws.cue aws_config_bootstrap
[profile defn-org]
sso_account_id=\(lookup["defn"].account["org"].id)
sso_role_name=\(lookup["defn"].account["org"].sso_role)
sso_start_url=\(lookup["defn"].sso_url)
sso_region=\(lookup["defn"].sso_region)
"""

		if "\(org)-\(account)" != "defn-org" {
			aws_config: strings.Join([aws_config_account, aws_config_bootstrap], "\n\n")
		}

		if "\(org)-\(account)" == "defn-org" {
			aws_config: aws_config_account
		}

		account_readme: """
## AWS Environment: \(org)-\(account)

```bash
cd a/\(org)/\(account)
mise trust
aws sso login
alogin
```

auto-generated: aws.cue account_readme
"""

		infra_org_readme: """
## Organizational-level Terraform: \(org)-\(account)

```bash
cd infra/org-\(org)
mise trust
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_org_readme
"""

		infra_org_terraform?: string

		infra_acc_readme: """
## Account-specific Terraform: \(org)-\(account)

```bash
cd infra/acc-\(org)-\(account)
mise trust
aws sso login --profile defn-org
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
"""

		infra_acc_terraform: """
terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-\(org)-\(account)/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "\(org)-\(account)"
  region  = "us-east-1"
  alias   = "\(org)-\(account)"
}

module "\(org)-\(account)" {
  account   = \(lookup["defn"].account["org"].id)
  name      = "terraform"
  namespace = "\(org)"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.\(org)-\(account)
  }
}
"""
	})
})
