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
    key            = "stacks/org-whoa/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "whoa-org"
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
resource "aws_organizations_account" "whoa_org" {
  email = "aws-whoa@defn.us"
  name  = "whoa-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "whoa_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.whoa_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "whoa_dev" {
  email = "whoa-dev@imma.io"
  name  = "whoa-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "whoa_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.whoa_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "whoa_hub" {
  email = "whoa-hub@imma.io"
  name  = "whoa-hub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "whoa_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.whoa_hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "whoa_net" {
  email = "whoa-secrets@imma.io"
  name  = "whoa-net"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "whoa_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.whoa_net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "whoa_pub" {
  email = "whoa-prod@imma.io"
  name  = "whoa-pub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "whoa_pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.whoa_pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.whoa-org
  to   = aws_organizations_account.whoa_org
}
moved {
  from = aws_organizations_account.whoa-dev
  to   = aws_organizations_account.whoa_dev
}
moved {
  from = aws_organizations_account.whoa-hub
  to   = aws_organizations_account.whoa_hub
}
moved {
  from = aws_organizations_account.whoa-net
  to   = aws_organizations_account.whoa_net
}
moved {
  from = aws_organizations_account.whoa-pub
  to   = aws_organizations_account.whoa_pub
}
moved {
  from = aws_ssoadmin_account_assignment.whoa-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.whoa_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.whoa-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.whoa_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.whoa-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.whoa_hub_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.whoa-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.whoa_net_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.whoa-pub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.whoa_pub_admin_sso_account_assignment
}
