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
    key            = "stacks/org-helix/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "helix-org"
  region  = "us-east-2"
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
resource "aws_organizations_account" "helix" {
  email = "aws-helix@defn.sh"
  name  = "helix"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "sec" {
  email = "aws-helix+sec@defn.sh"
  name  = "sec"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "sec_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.sec.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "dev" {
  email = "aws-helix+dev@defn.sh"
  name  = "dev"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "hub" {
  email = "aws-helix+hub@defn.sh"
  name  = "hub"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "lib" {
  email = "aws-helix+lib@defn.sh"
  name  = "lib"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "log" {
  email = "aws-helix+log@defn.sh"
  name  = "log"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "log_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.log.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "net" {
  email = "aws-helix+net@defn.sh"
  name  = "net"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "ops" {
  email = "aws-helix+ops@defn.sh"
  name  = "ops"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "ops_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.ops.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "dmz" {
  email = "aws-helix+dmz@defn.sh"
  name  = "dmz"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "dmz_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.dmz.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "pub" {
  email = "aws-helix+pub@defn.sh"
  name  = "pub"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.helix-org
  to   = aws_organizations_account.helix
}
moved {
  from = aws_organizations_account.helix-ci
  to   = aws_organizations_account.sec
}
moved {
  from = aws_organizations_account.helix-dev
  to   = aws_organizations_account.dev
}
moved {
  from = aws_organizations_account.helix-hub
  to   = aws_organizations_account.hub
}
moved {
  from = aws_organizations_account.helix-lib
  to   = aws_organizations_account.lib
}
moved {
  from = aws_organizations_account.helix-log
  to   = aws_organizations_account.log
}
moved {
  from = aws_organizations_account.helix-net
  to   = aws_organizations_account.net
}
moved {
  from = aws_organizations_account.helix-ops
  to   = aws_organizations_account.ops
}
moved {
  from = aws_organizations_account.helix-prod
  to   = aws_organizations_account.dmz
}
moved {
  from = aws_organizations_account.helix-pub
  to   = aws_organizations_account.pub
}
