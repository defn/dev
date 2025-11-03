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
    key            = "stacks/org-imma/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "imma-org"
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
resource "aws_organizations_account" "imma_org" {
  email = "aws-imma@defn.us"
  name  = "imma-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma_dev" {
  email = "imma-dev@imma.io"
  name  = "imma-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma_lib" {
  email = "imma-tolan@defn.us"
  name  = "imma-lib"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma_log" {
  email = "imma-dgwyn@defn.us"
  name  = "imma-log"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_log_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_log.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma_net" {
  email = "imma-defn@defn.us"
  name  = "imma-net"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma_pub" {
  email = "imma-prod@imma.io"
  name  = "imma-pub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "imma_pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma_pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.imma-org
  to   = aws_organizations_account.imma_org
}
moved {
  from = aws_organizations_account.imma-dev
  to   = aws_organizations_account.imma_dev
}
moved {
  from = aws_organizations_account.imma-lib
  to   = aws_organizations_account.imma_lib
}
moved {
  from = aws_organizations_account.imma-log
  to   = aws_organizations_account.imma_log
}
moved {
  from = aws_organizations_account.imma-net
  to   = aws_organizations_account.imma_net
}
moved {
  from = aws_organizations_account.imma-pub
  to   = aws_organizations_account.imma_pub
}
moved {
  from = aws_ssoadmin_account_assignment.imma-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.imma-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.imma-lib_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_lib_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.imma-log_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_log_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.imma-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_net_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.imma-pub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.imma_pub_admin_sso_account_assignment
}
