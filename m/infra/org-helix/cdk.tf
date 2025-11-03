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
resource "aws_organizations_account" "helix_org" {
  email = "aws-helix@defn.sh"
  name  = "helix-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_ci" {
  email = "aws-helix+sec@defn.sh"
  name  = "helix-ci"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_ci_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_ci.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_dev" {
  email = "aws-helix+dev@defn.sh"
  name  = "helix-dev"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_hub" {
  email = "aws-helix+hub@defn.sh"
  name  = "helix-hub"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_hub.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_lib" {
  email = "aws-helix+lib@defn.sh"
  name  = "helix-lib"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_lib_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_lib.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_log" {
  email = "aws-helix+log@defn.sh"
  name  = "helix-log"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_log_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_log.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_net" {
  email = "aws-helix+net@defn.sh"
  name  = "helix-net"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_net_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_net.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_ops" {
  email = "aws-helix+ops@defn.sh"
  name  = "helix-ops"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_ops_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_ops.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_prod" {
  email = "aws-helix+dmz@defn.sh"
  name  = "helix-prod"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_prod_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_prod.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "helix_pub" {
  email = "aws-helix+pub@defn.sh"
  name  = "helix-pub"
		  iam_user_access_to_billing = "ALLOW"
		  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "helix_pub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.helix_pub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.helix
  to   = aws_organizations_account.helix_org
}
moved {
  from = aws_organizations_account.sec
  to   = aws_organizations_account.helix_ci
}
moved {
  from = aws_organizations_account.dev
  to   = aws_organizations_account.helix_dev
}
moved {
  from = aws_organizations_account.hub
  to   = aws_organizations_account.helix_hub
}
moved {
  from = aws_organizations_account.lib
  to   = aws_organizations_account.helix_lib
}
moved {
  from = aws_organizations_account.log
  to   = aws_organizations_account.helix_log
}
moved {
  from = aws_organizations_account.net
  to   = aws_organizations_account.helix_net
}
moved {
  from = aws_organizations_account.ops
  to   = aws_organizations_account.helix_ops
}
moved {
  from = aws_organizations_account.dmz
  to   = aws_organizations_account.helix_prod
}
moved {
  from = aws_organizations_account.pub
  to   = aws_organizations_account.helix_pub
}
moved {
  from = aws_ssoadmin_account_assignment.helix-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-ci_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_ci_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_hub_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-lib_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_lib_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-log_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_log_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-net_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_net_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-ops_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_ops_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-prod_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_prod_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.helix-pub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.helix_pub_admin_sso_account_assignment
}
