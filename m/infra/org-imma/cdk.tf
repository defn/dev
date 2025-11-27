# auto-generated: aws.cue infra_org_terraform
terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    profile      = "defn-org"
    bucket       = "dfn-defn-terraform-state"
    use_lockfile = true
    key          = "stacks/org-imma/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
  }

}

provider "aws" {
  profile = "imma-org"
  region  = "us-west-2"
}

data "aws_caller_identity" "current" {}

data "aws_ssoadmin_instances" "sso_instance" {}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
  aws_config = jsonencode({
    "imma-org" : {
      account_id = data.aws_caller_identity.current.account_id
    }
  })
}

output "aws_config" {
  value = local.aws_config
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
