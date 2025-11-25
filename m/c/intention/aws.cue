@experiment(aliasv2)
@experiment(explicitopen)

package intention

import (
	"strings"
)

bootstrap: {
	org:     "defn"
	account: "org"
	profile: "\(org)-\(account)"
	bucket:  "dfn-defn-terraform-state"
}

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

		if "\(org)-\(account)" != bootstrap.profile {
			aws_config: strings.Join([aws_config_account, aws_config_bootstrap], "\n\n")
		}

		if "\(org)-\(account)" == bootstrap.profile {
			aws_config: aws_config_account
		}

		mise_config: """
# auto-generated: aws.cue mise_config
[env]
AWS_PROFILE = "\(org)-\(account)"
AWS_REGION = "\(sso_region)"
AWS_CONFIG_FILE = "/home/ubuntu/m/aws/\(org)/\(account)/.aws/config"
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
[profile \(bootstrap.profile)]
sso_account_id=\(lookup[bootstrap.org].account[bootstrap.account].id)
sso_role_name=\(lookup[bootstrap.org].account[bootstrap.account].sso_role)
sso_start_url=\(lookup[bootstrap.org].sso_url)
sso_region=\(lookup[bootstrap.org].sso_region)
"""

		account_readme: """
## AWS Environment: \(org)-\(account)

```bash
cd aws/\(org)/\(account)
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

		if account == "org" {
			infra_org_terraform: strings.Join(["""
# auto-generated: aws.cue infra_org_terraform
terraform {
	required_providers {
		aws = {
			version = "5.99.1"
			source  = "aws"
		}
	}
	backend "s3" {
		profile        = "\(bootstrap.profile)"
		bucket         = "\(bootstrap.bucket)"
		use_lockfile   = true
		key            = "stacks/org-\(org)/terraform.tfstate"
		region         = "us-east-1"
		encrypt        = true
	}

}

provider "aws" {
	profile = "\(org)-\(account)"
	region  = "\(sso_region)"
}

data "aws_caller_identity" "current" {}

locals {
	sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
	sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

resource "aws_organizations_organization" "organization" {
	aws_service_access_principals = [
		"account.amazonaws.com",
		"iam.amazonaws.com",
		"cloudtrail.amazonaws.com",
		"config.amazonaws.com",
		"ram.amazonaws.com",
		"ssm.amazonaws.com",
		"sso.amazonaws.com",
		"tagpolicies.tag.amazonaws.com"
	]
	enabled_policy_types = [
		"SERVICE_CONTROL_POLICY",
		"TAG_POLICY"
	]
	feature_set = "ALL"
}

resource "aws_iam_organizations_features" "organization" {
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions"
  ]
}

data "aws_ssoadmin_instances" "sso_instance" {
}

resource "aws_ssoadmin_permission_set" "admin_sso_permission_set" {
	instance_arn     = element(local.sso_instance_arn, 0)
	name             = "Administrator"
	session_duration = "PT2H"
	tags = {
		ManagedBy = "Terraform"
	}
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_sso_managed_policy_attachment" {
	instance_arn       = aws_ssoadmin_permission_set.admin_sso_permission_set.instance_arn
	managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
	permission_set_arn = aws_ssoadmin_permission_set.admin_sso_permission_set.arn
}

resource "aws_identitystore_group" "administrators_sso_group" {
	display_name      = "Administrators"
	identity_store_id = element(local.sso_instance_isid, 0)
}
""",
				strings.Join([for acc_key, acc_data in lookup[org].account {"""
resource "aws_organizations_account" "\(strings.Replace(acc_data.name, "-", "_", -1))" {
	email = "\(acc_data.email)"
	name  = "\(acc_data.name)"\(strings.Join([
					if acc_data.iam_user_access_to_billing != _|_ {"\n\t\t  iam_user_access_to_billing = \"\(acc_data.iam_user_access_to_billing)\""},
					if acc_data.role_name != _|_ {"\n\t\t  role_name                  = \"\(acc_data.role_name)\""},
				], ""))
	tags = {
		ManagedBy = "Terraform"
	}
}

resource "aws_ssoadmin_account_assignment" "\(strings.Replace(acc_data.name, "-", "_", -1))_admin_sso_account_assignment" {
	instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
	permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
	principal_id       = aws_identitystore_group.administrators_sso_group.group_id
	principal_type     = "GROUP"
	target_id          = aws_organizations_account.\(strings.Replace(acc_data.name, "-", "_", -1)).id
	target_type        = "AWS_ACCOUNT"
}
"""
				}], "\n"),
			], "\n")
		}

		infra_acc_readme: """
## Account-specific Terraform: \(org)-\(account)

```bash
cd infra/acc-\(org)-\(account)
mise trust
aws sso login --profile \(bootstrap.profile)
aws sso login
terraform init
terraform plan
```

auto-generated: aws.cue infra_acc_readme
"""

		infra_acc_terraform: """
# auto-generated: aws.cue infra_acc_terraform
terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "\(bootstrap.bucket)"
	use_lockfile   = true
    encrypt        = true
    key            = "stacks/acc-\(org)-\(account)/terraform.tfstate"
    profile        = "\(bootstrap.profile)"
    region         = "us-east-1"
  }
}

provider "aws" {
  profile = "\(org)-\(account)"
  alias   = "\(org)-\(account)"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
	provider = aws.\(org)-\(account)
}

locals {
  aws_config = jsonencode({
	"\(org)-\(account)": {
		account_id = data.aws_caller_identity.current.account_id
	}
  })
}

variable "config" {}

module "\(org)-\(account)" {
  account   = \(lookup[bootstrap.org].account[bootstrap.account].id)
  name      = "terraform"
  namespace = "\(org)"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.\(org)-\(account)
  }

  config = var.config
}

output "auditor_arn" {
  value = module.\(org)-\(account).auditor_arn
}

output "aws_config" {
  value = local.aws_config
}
"""
	})
})
