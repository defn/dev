terraform {
  required_providers {
    aws = {
      version = "5.34.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/imma/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "imma-org-sso"
  region  = "us-west-2"
}
resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = [
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
resource "aws_organizations_account" "imma" {
  email = "aws-imma@defn.us"
  name  = "imma"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma-prod" {
  email = "imma-prod@imma.io"
  name  = "imma-prod"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma-prod_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma-prod.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma-dev" {
  email = "imma-dev@imma.io"
  name  = "imma-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma-dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma-dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma-tolan" {
  email = "imma-tolan@defn.us"
  name  = "imma-tolan"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma-tolan_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma-tolan.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma-dgwyn" {
  email = "imma-dgwyn@defn.us"
  name  = "imma-dgwyn"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma-dgwyn_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma-dgwyn.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "imma-defn" {
  email = "imma-defn@defn.us"
  name  = "imma-defn"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "imma-defn_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.imma-defn.id
  target_type        = "AWS_ACCOUNT"
}