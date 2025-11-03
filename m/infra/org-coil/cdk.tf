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
    key            = "stacks/org-coil/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "coil-org"
  region  = "us-east-1"
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
resource "aws_organizations_account" "coil_org" {
  email = "aws-coil@defn.us"
  name  = "coil-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "coil_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.coil_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "coil_hub" {
  email = "aws-coil+hub@defn.us"
  name  = "coil-hub"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "coil_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.coil_hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "coil_lib" {
  email = "aws-coil+lib@defn.us"
  name  = "coil-lib"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "coil_lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.coil_lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "coil_net" {
  email = "aws-coil+net@defn.us"
  name  = "coil-net"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "coil_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.coil_net.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.coil-org
  to   = aws_organizations_account.coil_org
}
moved {
  from = aws_organizations_account.coil-hub
  to   = aws_organizations_account.coil_hub
}
moved {
  from = aws_organizations_account.coil-lib
  to   = aws_organizations_account.coil_lib
}
moved {
  from = aws_organizations_account.coil-net
  to   = aws_organizations_account.coil_net
}
moved {
  from = aws_ssoadmin_account_assignment.coil-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.coil_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.coil-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.coil_hub_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.coil-lib_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.coil_lib_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.coil-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.coil_net_admin_sso_account_assignment
}
