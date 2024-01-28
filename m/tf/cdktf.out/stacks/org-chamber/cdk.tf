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
  email = "chamber-4@defn.us"
  name  = "chamber-4"
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
  email = "chamber-5@defn.us"
  name  = "chamber-5"
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
  email = "chamber-6@defn.us"
  name  = "chamber-6"
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
  email = "chamber-7@defn.us"
  name  = "chamber-7"
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
  email = "chamber-8@defn.us"
  name  = "chamber-8"
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
  email = "chamber-9@defn.us"
  name  = "chamber-9"
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
  email = "defn-m@defn.us"
  name  = "defn-m"
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
  email = "defn-n@defn.us"
  name  = "defn-n"
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
  email = "defn-o@defn.us"
  name  = "defn-o"
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
  email = "defn-p@defn.us"
  name  = "defn-p"
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
  email = "defn-r@imma.io"
  name  = "defn-r"
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
  email = "defn-s@imma.io"
  name  = "defn-s"
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
  email = "defn-t@imma.io"
  name  = "defn-t"
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
  email = "defn-v@imma.io"
  name  = "defn-v"
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
  email = "defn-w@imma.io"
  name  = "defn-w"
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
  email = "aws-admin1@defn.us"
  name  = "defn-i"
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
  email = "aws-development1@defn.us"
  name  = "defn-j"
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
resource "aws_organizations_account" "defn-l" {
  email = "aws-staging1@defn.us"
  name  = "defn-l"
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
  email = "defn-a@imma.io"
  name  = "defn-a"
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
  email = "imma-admin1@imma.io"
  name  = "defn-b"
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
  email = "dev-eng1@imma.io"
  name  = "defn-c"
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
  email = "box-adm1@imma.io"
  name  = "defn-d"
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
  email = "stg-eng1@imma.io"
  name  = "defn-e"
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
  email = "usr-admin1@imma.io"
  name  = "defn-f"
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
  email = "usr-adm1@imma.io"
  name  = "defn-g"
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
  email = "usr-eng1@imma.io"
  name  = "defn-h"
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
  email = "aws-hub@defn.us"
  name  = "defn-hub"
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
  email = "aws-prod@defn.us"
  name  = "defn-prod"
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
  email = "aws-qa@defn.us"
  name  = "defn-qa"
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
  email = "aws-users@defn.us"
  name  = "defn-security"
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
  email = "aws-stage@defn.us"
  name  = "defn-stage"
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
  email = "aws-cd@defn.us"
  name  = "defn-cd"
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
  email = "aws-ci@defn.us"
  name  = "defn-ci"
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
  email = "aws-dev@defn.us"
  name  = "defn-dev"
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