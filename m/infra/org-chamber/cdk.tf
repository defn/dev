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
    key            = "stacks/org-chamber/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

locals {
  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
}

provider "aws" {
  profile = "chamber-org"
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
resource "aws_organizations_account" "chamber" {
  email = "aws-chamber@defn.us"
  name  = "chamber"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_cd" {
  email = "aws-cd@defn.us"
  name  = "defn-cd"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_cd_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_cd.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_ci" {
  email = "aws-ci@defn.us"
  name  = "defn-ci"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_ci_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_ci.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_security" {
  email = "aws-users@defn.us"
  name  = "defn-security"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_security_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_security.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_4" {
  email = "chamber-4@defn.us"
  name  = "chamber-4"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_4_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_4.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_5" {
  email = "chamber-5@defn.us"
  name  = "chamber-5"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_5_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_5.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_6" {
  email = "chamber-6@defn.us"
  name  = "chamber-6"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_6_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_6.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_7" {
  email = "chamber-7@defn.us"
  name  = "chamber-7"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_7_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_7.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_8" {
  email = "chamber-8@defn.us"
  name  = "chamber-8"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_8_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_8.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_9" {
  email = "chamber-9@defn.us"
  name  = "chamber-9"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_9_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_9.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_a" {
  email = "defn-a@imma.io"
  name  = "defn-a"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_a_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_a.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_b" {
  email = "imma-admin1@imma.io"
  name  = "defn-b"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_b_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_b.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_c" {
  email = "dev-eng1@imma.io"
  name  = "defn-c"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_c_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_c.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_d" {
  email = "box-adm1@imma.io"
  name  = "defn-d"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_d_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_d.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_e" {
  email = "stg-eng1@imma.io"
  name  = "defn-e"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_e_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_e.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_f" {
  email = "usr-admin1@imma.io"
  name  = "defn-f"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_f_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_f.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_g" {
  email = "usr-adm1@imma.io"
  name  = "defn-g"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_g_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_g.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_h" {
  email = "usr-eng1@imma.io"
  name  = "defn-h"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_h_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_h.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_i" {
  email = "aws-admin1@defn.us"
  name  = "defn-i"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_i_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_i.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_j" {
  email = "aws-development1@defn.us"
  name  = "defn-j"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_j_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_j.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_l" {
  email = "aws-staging1@defn.us"
  name  = "defn-l"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_l_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_l.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_m" {
  email = "defn-m@defn.us"
  name  = "defn-m"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_m_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_m.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_n" {
  email = "defn-n@defn.us"
  name  = "defn-n"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_n_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_n.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_o" {
  email = "defn-o@defn.us"
  name  = "defn-o"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_o_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_o.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_p" {
  email = "defn-p@defn.us"
  name  = "defn-p"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_p_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_p.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_dev" {
  email = "aws-dev@defn.us"
  name  = "defn-dev"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_dev_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_dev.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_r" {
  email = "defn-r@imma.io"
  name  = "defn-r"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_r_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_r.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_s" {
  email = "defn-s@imma.io"
  name  = "defn-s"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_s_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_s.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_t" {
  email = "defn-t@imma.io"
  name  = "defn-t"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_t_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_t.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_qa" {
  email = "aws-qa@defn.us"
  name  = "defn-qa"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_qa_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_qa.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_v" {
  email = "defn-v@imma.io"
  name  = "defn-v"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_v_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_v.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_w" {
  email = "defn-w@imma.io"
  name  = "defn-w"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_w_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_w.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_stage" {
  email = "aws-stage@defn.us"
  name  = "defn-stage"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_stage_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_stage.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_prod" {
  email = "aws-prod@defn.us"
  name  = "defn-prod"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_prod_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_prod.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "defn_hub" {
  email = "aws-hub@defn.us"
  name  = "defn-hub"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "defn_hub_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.defn_hub.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.chamber-org
  to   = aws_organizations_account.chamber
}
moved {
  from = aws_organizations_account.chamber-1
  to   = aws_organizations_account.defn_cd
}
moved {
  from = aws_organizations_account.chamber-2
  to   = aws_organizations_account.defn_ci
}
moved {
  from = aws_organizations_account.chamber-3
  to   = aws_organizations_account.defn_security
}
moved {
  from = aws_organizations_account.chamber-4
  to   = aws_organizations_account.chamber_4
}
moved {
  from = aws_organizations_account.chamber-5
  to   = aws_organizations_account.chamber_5
}
moved {
  from = aws_organizations_account.chamber-6
  to   = aws_organizations_account.chamber_6
}
moved {
  from = aws_organizations_account.chamber-7
  to   = aws_organizations_account.chamber_7
}
moved {
  from = aws_organizations_account.chamber-8
  to   = aws_organizations_account.chamber_8
}
moved {
  from = aws_organizations_account.chamber-9
  to   = aws_organizations_account.chamber_9
}
moved {
  from = aws_organizations_account.chamber-a
  to   = aws_organizations_account.defn_a
}
moved {
  from = aws_organizations_account.chamber-b
  to   = aws_organizations_account.defn_b
}
moved {
  from = aws_organizations_account.chamber-c
  to   = aws_organizations_account.defn_c
}
moved {
  from = aws_organizations_account.chamber-d
  to   = aws_organizations_account.defn_d
}
moved {
  from = aws_organizations_account.chamber-e
  to   = aws_organizations_account.defn_e
}
moved {
  from = aws_organizations_account.chamber-f
  to   = aws_organizations_account.defn_f
}
moved {
  from = aws_organizations_account.chamber-g
  to   = aws_organizations_account.defn_g
}
moved {
  from = aws_organizations_account.chamber-h
  to   = aws_organizations_account.defn_h
}
moved {
  from = aws_organizations_account.chamber-i
  to   = aws_organizations_account.defn_i
}
moved {
  from = aws_organizations_account.chamber-j
  to   = aws_organizations_account.defn_j
}
moved {
  from = aws_organizations_account.chamber-l
  to   = aws_organizations_account.defn_l
}
moved {
  from = aws_organizations_account.chamber-m
  to   = aws_organizations_account.defn_m
}
moved {
  from = aws_organizations_account.chamber-n
  to   = aws_organizations_account.defn_n
}
moved {
  from = aws_organizations_account.chamber-o
  to   = aws_organizations_account.defn_o
}
moved {
  from = aws_organizations_account.chamber-p
  to   = aws_organizations_account.defn_p
}
moved {
  from = aws_organizations_account.chamber-q
  to   = aws_organizations_account.defn_dev
}
moved {
  from = aws_organizations_account.chamber-r
  to   = aws_organizations_account.defn_r
}
moved {
  from = aws_organizations_account.chamber-s
  to   = aws_organizations_account.defn_s
}
moved {
  from = aws_organizations_account.chamber-t
  to   = aws_organizations_account.defn_t
}
moved {
  from = aws_organizations_account.chamber-u
  to   = aws_organizations_account.defn_qa
}
moved {
  from = aws_organizations_account.chamber-v
  to   = aws_organizations_account.defn_v
}
moved {
  from = aws_organizations_account.chamber-w
  to   = aws_organizations_account.defn_w
}
moved {
  from = aws_organizations_account.chamber-x
  to   = aws_organizations_account.defn_stage
}
moved {
  from = aws_organizations_account.chamber-y
  to   = aws_organizations_account.defn_prod
}
moved {
  from = aws_organizations_account.chamber-z
  to   = aws_organizations_account.defn_hub
}
moved {
  from = aws_ssoadmin_account_assignment.defn-cd_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_cd_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-ci_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_ci_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-security_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_security_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-4_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_4_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-5_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_5_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-6_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_6_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-7_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_7_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-8_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_8_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-9_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_9_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-a_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_a_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-b_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_b_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-c_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_c_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-d_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_d_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-e_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_e_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-f_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_f_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-g_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_g_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-h_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_h_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-i_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_i_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-j_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_j_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-l_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_l_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-m_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_m_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-n_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_n_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-o_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_o_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-p_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_p_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-dev_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_dev_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-r_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_r_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-s_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_s_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-t_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_t_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-qa_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_qa_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-v_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_v_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-w_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_w_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-stage_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_stage_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-prod_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_prod_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.defn-hub_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.defn_hub_admin_sso_account_assignment
}
