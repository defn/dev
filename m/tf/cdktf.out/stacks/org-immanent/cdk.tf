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
    key            = "stacks/org-immanent/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "immanent-org-sso"
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
resource "aws_organizations_account" "immanent" {
  email = "aws-immanent@defn.us"
  name  = "immanent"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-patterner" {
  email = "immanent-patterner@defn.us"
  name  = "immanent-patterner"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-patterner_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-patterner.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-windkey" {
  email = "immanent-windkey@defn.us"
  name  = "immanent-windkey"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-windkey_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-windkey.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-summoner" {
  email = "immanent-summoner@defn.us"
  name  = "immanent-summoner"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-summoner_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-summoner.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-herbal" {
  email = "immanent-herbal@defn.us"
  name  = "immanent-herbal"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-herbal_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-herbal.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-namer" {
  email = "immanent-namer@defn.us"
  name  = "immanent-namer"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-namer_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-namer.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-ged" {
  email = "immanent-ged@defn.us"
  name  = "immanent-ged"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-ged_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-ged.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-roke" {
  email = "immanent-roke@defn.us"
  name  = "immanent-roke"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-roke_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-roke.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-chanter" {
  email = "immanent-chanter@defn.us"
  name  = "immanent-chanter"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-chanter_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-chanter.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-changer" {
  email = "immanent-changer@defn.us"
  name  = "immanent-changer"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-changer_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-changer.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-hand" {
  email = "immanent-hand@defn.us"
  name  = "immanent-hand"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-hand_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-hand.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "immanent-doorkeeper" {
  email = "immanent-doorkeeper@defn.us"
  name  = "immanent-doorkeeper"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "immanent-doorkeeper_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.immanent-doorkeeper.id
  target_type        = "AWS_ACCOUNT"
}