terraform {
  required_providers {
    aws = {
      version = "5.94.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/org-fogg/terraform.tfstate"
    profile        = "defn-org-sso-source"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "fogg-org-sso-source"
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

resource "aws_organizations_account" "fogg-org" {
  email = "spiral@defn.sh"
  name  = "fogg"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "fogg_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-org.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-net" {
  email = "fogg-asset@defn.sh"
  name  = "fogg-asset"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "asset_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-net.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-log" {
  email = "fogg-circus@defn.sh"
  name  = "fogg-circus"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "circus_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-log.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-lib" {
  email = "fogg-data@defn.sh"
  name  = "fogg-data"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "data_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-lib.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-ops" {
  email = "fogg-gateway@defn.sh"
  name  = "fogg-gateway"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "gateway_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-ops.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-ci" {
  email = "fogg-home@defn.sh"
  name  = "fogg-home"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "home_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-ci.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-hub" {
  email = "fogg-hub@defn.sh"
  name  = "fogg-hub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-hub.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-prod" {
  email = "fogg-postx@defn.sh"
  name  = "fogg-postx"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "postx_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-prod.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-dev" {
  email = "fogg-sandbox@defn.sh"
  name  = "fogg-sandbox"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "sandbox_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-dev.id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_organizations_account" "fogg-pub" {
  email = "fogg-security@defn.sh"
  name  = "fogg-security"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "security_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.fogg-pub.id
  target_type        = "AWS_ACCOUNT"
}
