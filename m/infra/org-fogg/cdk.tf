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
    key            = "stacks/org-fogg/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "fogg-org"
  region  = "us-west-2"
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
resource "aws_organizations_account" "fogg_org" {
  email = "spiral@defn.sh"
  name  = "fogg-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_ci" {
  email = "fogg-home@defn.sh"
  name  = "fogg-ci"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_ci_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_ci.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_dev" {
  email = "fogg-sandbox@defn.sh"
  name  = "fogg-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_hub" {
  email = "fogg-hub@defn.sh"
  name  = "fogg-hub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_lib" {
  email = "fogg-data@defn.sh"
  name  = "fogg-lib"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_log" {
  email = "fogg-circus@defn.sh"
  name  = "fogg-log"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_log_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_log.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_net" {
  email = "fogg-asset@defn.sh"
  name  = "fogg-net"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_ops" {
  email = "fogg-gateway@defn.sh"
  name  = "fogg-ops"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_ops_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_ops.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_prod" {
  email = "fogg-postx@defn.sh"
  name  = "fogg-prod"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_prod_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_prod.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "fogg_pub" {
  email = "fogg-security@defn.sh"
  name  = "fogg-pub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg_pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.fogg-org
  to   = aws_organizations_account.fogg_org
}
moved {
  from = aws_organizations_account.fogg-ci
  to   = aws_organizations_account.fogg_ci
}
moved {
  from = aws_organizations_account.fogg-dev
  to   = aws_organizations_account.fogg_dev
}
moved {
  from = aws_organizations_account.fogg-hub
  to   = aws_organizations_account.fogg_hub
}
moved {
  from = aws_organizations_account.fogg-lib
  to   = aws_organizations_account.fogg_lib
}
moved {
  from = aws_organizations_account.fogg-log
  to   = aws_organizations_account.fogg_log
}
moved {
  from = aws_organizations_account.fogg-net
  to   = aws_organizations_account.fogg_net
}
moved {
  from = aws_organizations_account.fogg-ops
  to   = aws_organizations_account.fogg_ops
}
moved {
  from = aws_organizations_account.fogg-prod
  to   = aws_organizations_account.fogg_prod
}
moved {
  from = aws_organizations_account.fogg-pub
  to   = aws_organizations_account.fogg_pub
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-ci_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_ci_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_hub_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-lib_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_lib_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-log_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_log_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_net_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-ops_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_ops_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-prod_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_prod_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.fogg-pub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.fogg_pub_admin_sso_account_assignment
}
