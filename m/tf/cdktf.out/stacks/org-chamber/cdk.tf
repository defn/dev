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
    key            = "stacks/chamber/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

locals {
  sso_instance_arn  = "${data.aws_ssoadmin_instances.sso_instance.arns}"
  sso_instance_isid = "${data.aws_ssoadmin_instances.sso_instance.identity_store_ids}"
}

provider "aws" {
  profile = "chamber-org-sso"
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
  instance_arn     = "${element(local.sso_instance_arn, 0)}"
  name             = "Administrator"
  session_duration = "PT2H"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_managed_policy_attachment" "admin_sso_managed_policy_attachment" {
  instance_arn       = "${aws_ssoadmin_permission_set.admin_sso_permission_set.instance_arn}"
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = "${aws_ssoadmin_permission_set.admin_sso_permission_set.arn}"
}
resource "aws_identitystore_group" "administrators_sso_group" {
  display_name      = "Administrators"
  identity_store_id = "${element(local.sso_instance_isid, 0)}"
}
resource "aws_organizations_account" "chamber" {
  email = "aws-chamber@defn.us"
  name  = "chamber"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-4" {
  email                      = "chamber-4@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-4"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-4_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-4.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-5" {
  email                      = "chamber-5@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-5"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-5_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-5.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-6" {
  email                      = "chamber-6@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-6"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-6_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-6.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-7" {
  email                      = "chamber-7@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-7"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-7_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-7.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-8" {
  email                      = "chamber-8@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-8"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-8_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-8.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber-9" {
  email                      = "chamber-9@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "chamber-9"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "chamber-9_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.chamber-9.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-m" {
  email                      = "defn-m@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-m"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-m_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-m.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-n" {
  email                      = "defn-n@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-n"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-n_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-n.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-o" {
  email                      = "defn-o@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-o"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-o_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-o.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-p" {
  email                      = "defn-p@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-p"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-p_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-p.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-r" {
  email                      = "defn-r@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-r"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-r_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-r.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-s" {
  email                      = "defn-s@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-s"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-s_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-s.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-t" {
  email                      = "defn-t@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-t"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-t_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-t.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-v" {
  email                      = "defn-v@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-v"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-v_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-v.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-w" {
  email                      = "defn-w@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-w"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-w_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-w.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-i" {
  email                      = "aws-admin1@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-i"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-i_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-i.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-j" {
  email                      = "aws-development1@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-j"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-j_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-j.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-k" {
  email                      = "aws-production1@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-k"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-k_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-k.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-l" {
  email                      = "aws-staging1@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-l"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-l_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-l.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-a" {
  email                      = "defn-a@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-a"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-a_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-a.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-b" {
  email                      = "imma-admin1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-b"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-b_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-b.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-c" {
  email                      = "dev-eng1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-c"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-c_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-c.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-d" {
  email                      = "box-adm1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-d"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-d_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-d.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-e" {
  email                      = "stg-eng1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-e"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-e_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-e.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-f" {
  email                      = "usr-admin1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-f"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-f_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-f.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-g" {
  email                      = "usr-adm1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-g"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-g_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-g.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-h" {
  email                      = "usr-eng1@imma.io"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-h"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-h_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-h.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-hub" {
  email                      = "aws-hub@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-hub"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-hub_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-hub.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-prod" {
  email                      = "aws-prod@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-prod"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-prod_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-prod.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-qa" {
  email                      = "aws-qa@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-qa"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-qa_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-qa.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-security" {
  email                      = "aws-users@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-security"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-security_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-security.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-stage" {
  email                      = "aws-stage@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-stage"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-stage_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-stage.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-cd" {
  email                      = "aws-cd@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-cd"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-cd_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-cd.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-ci" {
  email                      = "aws-ci@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-ci"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-ci_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-ci.id}"
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn-dev" {
  email                      = "aws-dev@defn.us"
  iam_user_access_to_billing = "ALLOW"
  name                       = "defn-dev"
  role_name                  = "OrganizationAccountAccessRole"
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_ssoadmin_account_assignment" "defn-dev_admin_sso_account_assignment" {
  instance_arn       = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn}"
  permission_set_arn = "${aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn}"
  principal_id       = "${aws_identitystore_group.administrators_sso_group.group_id}"
  principal_type     = "GROUP"
  target_id          = "${aws_organizations_account.defn-dev.id}"
  target_type        = "AWS_ACCOUNT"
}