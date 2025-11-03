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
resource "aws_organizations_account" "chamber_org" {
  email = "aws-chamber@defn.us"
  name  = "chamber-org"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_org_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_org.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_1" {
  email = "aws-cd@defn.us"
  name  = "chamber-1"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_1_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_1.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_2" {
  email = "aws-ci@defn.us"
  name  = "chamber-2"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_2_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_2.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_3" {
  email = "aws-users@defn.us"
  name  = "chamber-3"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_3_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_3.id
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
resource "aws_organizations_account" "chamber_a" {
  email = "defn-a@imma.io"
  name  = "chamber-a"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_a_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_a.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_b" {
  email = "imma-admin1@imma.io"
  name  = "chamber-b"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_b_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_b.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_c" {
  email = "dev-eng1@imma.io"
  name  = "chamber-c"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_c_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_c.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_d" {
  email = "box-adm1@imma.io"
  name  = "chamber-d"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_d_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_d.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_e" {
  email = "stg-eng1@imma.io"
  name  = "chamber-e"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_e_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_e.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_f" {
  email = "usr-admin1@imma.io"
  name  = "chamber-f"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_f_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_f.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_g" {
  email = "usr-adm1@imma.io"
  name  = "chamber-g"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_g_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_g.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_h" {
  email = "usr-eng1@imma.io"
  name  = "chamber-h"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_h_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_h.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_i" {
  email = "aws-admin1@defn.us"
  name  = "chamber-i"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_i_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_i.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_j" {
  email = "aws-development1@defn.us"
  name  = "chamber-j"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_j_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_j.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_l" {
  email = "aws-staging1@defn.us"
  name  = "chamber-l"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_l_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_l.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_m" {
  email = "defn-m@defn.us"
  name  = "chamber-m"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_m_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_m.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_n" {
  email = "defn-n@defn.us"
  name  = "chamber-n"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_n_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_n.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_o" {
  email = "defn-o@defn.us"
  name  = "chamber-o"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_o_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_o.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_p" {
  email = "defn-p@defn.us"
  name  = "chamber-p"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_p_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_p.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_q" {
  email = "aws-dev@defn.us"
  name  = "chamber-q"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_q_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_q.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_r" {
  email = "defn-r@imma.io"
  name  = "chamber-r"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_r_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_r.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_s" {
  email = "defn-s@imma.io"
  name  = "chamber-s"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_s_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_s.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_t" {
  email = "defn-t@imma.io"
  name  = "chamber-t"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_t_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_t.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_u" {
  email = "aws-qa@defn.us"
  name  = "chamber-u"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_u_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_u.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_v" {
  email = "defn-v@imma.io"
  name  = "chamber-v"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_v_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_v.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_w" {
  email = "defn-w@imma.io"
  name  = "chamber-w"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_w_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_w.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_x" {
  email = "aws-stage@defn.us"
  name  = "chamber-x"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_x_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_x.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_y" {
  email = "aws-prod@defn.us"
  name  = "chamber-y"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_y_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_y.id
  target_type        = "AWS_ACCOUNT"
}
resource "aws_organizations_account" "chamber_z" {
  email = "aws-hub@defn.us"
  name  = "chamber-z"
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_ssoadmin_account_assignment" "chamber_z_admin_sso_account_assignment" {
  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
  principal_type     = "GROUP"
  target_id          = aws_organizations_account.chamber_z.id
  target_type        = "AWS_ACCOUNT"
}
moved {
  from = aws_organizations_account.chamber-org
  to   = aws_organizations_account.chamber_org
}
moved {
  from = aws_organizations_account.chamber-1
  to   = aws_organizations_account.chamber_1
}
moved {
  from = aws_organizations_account.chamber-2
  to   = aws_organizations_account.chamber_2
}
moved {
  from = aws_organizations_account.chamber-3
  to   = aws_organizations_account.chamber_3
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
  to   = aws_organizations_account.chamber_a
}
moved {
  from = aws_organizations_account.chamber-b
  to   = aws_organizations_account.chamber_b
}
moved {
  from = aws_organizations_account.chamber-c
  to   = aws_organizations_account.chamber_c
}
moved {
  from = aws_organizations_account.chamber-d
  to   = aws_organizations_account.chamber_d
}
moved {
  from = aws_organizations_account.chamber-e
  to   = aws_organizations_account.chamber_e
}
moved {
  from = aws_organizations_account.chamber-f
  to   = aws_organizations_account.chamber_f
}
moved {
  from = aws_organizations_account.chamber-g
  to   = aws_organizations_account.chamber_g
}
moved {
  from = aws_organizations_account.chamber-h
  to   = aws_organizations_account.chamber_h
}
moved {
  from = aws_organizations_account.chamber-i
  to   = aws_organizations_account.chamber_i
}
moved {
  from = aws_organizations_account.chamber-j
  to   = aws_organizations_account.chamber_j
}
moved {
  from = aws_organizations_account.chamber-l
  to   = aws_organizations_account.chamber_l
}
moved {
  from = aws_organizations_account.chamber-m
  to   = aws_organizations_account.chamber_m
}
moved {
  from = aws_organizations_account.chamber-n
  to   = aws_organizations_account.chamber_n
}
moved {
  from = aws_organizations_account.chamber-o
  to   = aws_organizations_account.chamber_o
}
moved {
  from = aws_organizations_account.chamber-p
  to   = aws_organizations_account.chamber_p
}
moved {
  from = aws_organizations_account.chamber-q
  to   = aws_organizations_account.chamber_q
}
moved {
  from = aws_organizations_account.chamber-r
  to   = aws_organizations_account.chamber_r
}
moved {
  from = aws_organizations_account.chamber-s
  to   = aws_organizations_account.chamber_s
}
moved {
  from = aws_organizations_account.chamber-t
  to   = aws_organizations_account.chamber_t
}
moved {
  from = aws_organizations_account.chamber-u
  to   = aws_organizations_account.chamber_u
}
moved {
  from = aws_organizations_account.chamber-v
  to   = aws_organizations_account.chamber_v
}
moved {
  from = aws_organizations_account.chamber-w
  to   = aws_organizations_account.chamber_w
}
moved {
  from = aws_organizations_account.chamber-x
  to   = aws_organizations_account.chamber_x
}
moved {
  from = aws_organizations_account.chamber-y
  to   = aws_organizations_account.chamber_y
}
moved {
  from = aws_organizations_account.chamber-z
  to   = aws_organizations_account.chamber_z
}
moved {
  from = aws_organizations_account.chamber
  to   = aws_organizations_account.chamber_org
}
moved {
  from = aws_organizations_account.defn_cd
  to   = aws_organizations_account.chamber_1
}
moved {
  from = aws_organizations_account.defn_ci
  to   = aws_organizations_account.chamber_2
}
moved {
  from = aws_organizations_account.defn_security
  to   = aws_organizations_account.chamber_3
}
moved {
  from = aws_organizations_account.defn_a
  to   = aws_organizations_account.chamber_a
}
moved {
  from = aws_organizations_account.defn_b
  to   = aws_organizations_account.chamber_b
}
moved {
  from = aws_organizations_account.defn_c
  to   = aws_organizations_account.chamber_c
}
moved {
  from = aws_organizations_account.defn_d
  to   = aws_organizations_account.chamber_d
}
moved {
  from = aws_organizations_account.defn_e
  to   = aws_organizations_account.chamber_e
}
moved {
  from = aws_organizations_account.defn_f
  to   = aws_organizations_account.chamber_f
}
moved {
  from = aws_organizations_account.defn_g
  to   = aws_organizations_account.chamber_g
}
moved {
  from = aws_organizations_account.defn_h
  to   = aws_organizations_account.chamber_h
}
moved {
  from = aws_organizations_account.defn_i
  to   = aws_organizations_account.chamber_i
}
moved {
  from = aws_organizations_account.defn_j
  to   = aws_organizations_account.chamber_j
}
moved {
  from = aws_organizations_account.defn_l
  to   = aws_organizations_account.chamber_l
}
moved {
  from = aws_organizations_account.defn_m
  to   = aws_organizations_account.chamber_m
}
moved {
  from = aws_organizations_account.defn_n
  to   = aws_organizations_account.chamber_n
}
moved {
  from = aws_organizations_account.defn_o
  to   = aws_organizations_account.chamber_o
}
moved {
  from = aws_organizations_account.defn_p
  to   = aws_organizations_account.chamber_p
}
moved {
  from = aws_organizations_account.defn_dev
  to   = aws_organizations_account.chamber_q
}
moved {
  from = aws_organizations_account.defn_r
  to   = aws_organizations_account.chamber_r
}
moved {
  from = aws_organizations_account.defn_s
  to   = aws_organizations_account.chamber_s
}
moved {
  from = aws_organizations_account.defn_t
  to   = aws_organizations_account.chamber_t
}
moved {
  from = aws_organizations_account.defn_qa
  to   = aws_organizations_account.chamber_u
}
moved {
  from = aws_organizations_account.defn_v
  to   = aws_organizations_account.chamber_v
}
moved {
  from = aws_organizations_account.defn_w
  to   = aws_organizations_account.chamber_w
}
moved {
  from = aws_organizations_account.defn_stage
  to   = aws_organizations_account.chamber_x
}
moved {
  from = aws_organizations_account.defn_prod
  to   = aws_organizations_account.chamber_y
}
moved {
  from = aws_organizations_account.defn_hub
  to   = aws_organizations_account.chamber_z
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-org_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_org_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-1_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_1_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-2_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_2_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-3_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_3_admin_sso_account_assignment
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
  from = aws_ssoadmin_account_assignment.chamber-a_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_a_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-b_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_b_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-c_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_c_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-d_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_d_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-e_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_e_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-f_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_f_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-g_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_g_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-h_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_h_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-i_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_i_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-j_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_j_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-l_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_l_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-m_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_m_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-n_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_n_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-o_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_o_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-p_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_p_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-q_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_q_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-r_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_r_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-s_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_s_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-t_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_t_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-u_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_u_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-v_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_v_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-w_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_w_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-x_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_x_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-y_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_y_admin_sso_account_assignment
}
moved {
  from = aws_ssoadmin_account_assignment.chamber-z_admin_sso_account_assignment
  to   = aws_ssoadmin_account_assignment.chamber_z_admin_sso_account_assignment
}
