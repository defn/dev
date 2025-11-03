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
    key            = "stacks/org-vault/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "vault-org"
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
resource "aws_organizations_account" "vault_org" {
  email = "aws-vault@defn.us"
  name  = "vault-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_ci" {
  email = "aws-vault-vault0@defn.sh"
  name  = "vault-ci"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_ci_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_ci.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_dev" {
  email = "aws-vault-dev@defn.sh"
  name  = "vault-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_hub" {
  email = "aws-vault-hub@defn.sh"
  name  = "vault-hub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_lib" {
  email = "aws-vault-library@defn.sh"
  name  = "vault-lib"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_log" {
  email = "aws-vault-audit@defn.sh"
  name  = "vault-log"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_log_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_log.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_net" {
  email = "aws-vault-transit@defn.sh"
  name  = "vault-net"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_ops" {
  email = "aws-vault-ops@defn.sh"
  name  = "vault-ops"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_ops_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_ops.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_prod" {
  email = "aws-vault-vault1@defn.sh"
  name  = "vault-prod"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_prod_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_prod.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "vault_pub" {
  email = "aws-vault-pub@defn.sh"
  name  = "vault-pub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "vault_pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.vault_pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.vault-org
  to   = aws_organizations_account.vault_org
}
moved {
  from = aws_organizations_account.vault-ci
  to   = aws_organizations_account.vault_ci
}
moved {
  from = aws_organizations_account.vault-dev
  to   = aws_organizations_account.vault_dev
}
moved {
  from = aws_organizations_account.vault-hub
  to   = aws_organizations_account.vault_hub
}
moved {
  from = aws_organizations_account.vault-lib
  to   = aws_organizations_account.vault_lib
}
moved {
  from = aws_organizations_account.vault-log
  to   = aws_organizations_account.vault_log
}
moved {
  from = aws_organizations_account.vault-net
  to   = aws_organizations_account.vault_net
}
moved {
  from = aws_organizations_account.vault-ops
  to   = aws_organizations_account.vault_ops
}
moved {
  from = aws_organizations_account.vault-prod
  to   = aws_organizations_account.vault_prod
}
moved {
  from = aws_organizations_account.vault-pub
  to   = aws_organizations_account.vault_pub
}
moved {
  from = aws_ssoadmin_account_assignment.vault-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-ci_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_ci_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_hub_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-lib_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_lib_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-log_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_log_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_net_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-ops_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_ops_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-prod_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_prod_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.vault-pub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.vault_pub_admin_sso_account_assignment
}
