data "aws_iam_policy_document" "resource_full_access" {
  statement {
    sid    = "FullAccess"
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "*"
    ]
  }
}

module "terraform_role" {
  source = "../terraform-aws-iam-role"

  context = module.this.context

  policy_description = "Allow Full Access"
  role_description   = "Account Terraform Role"

  principals = {
    AWS = ["arn:aws:iam::${var.account}:root"]
  }

  policy_documents = [
    data.aws_iam_policy_document.resource_full_access.json
  ]
}

data "aws_iam_policy" "readonly" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "auditor_access" {
  statement {
    effect = "Allow"

    resources = [
    ]

    actions = [
    ]
  }
}

module "auditor_role" {
  source = "../terraform-aws-iam-role"

  context      = module.this.context
  name         = "auditor"
  use_fullname = false

  policy_description = "Read Only"
  role_description   = "Account Auditor Role"

  principals = {
    AWS = ["arn:aws:iam::${var.account}:root"]
  }

  policy_documents = [
    data.aws_iam_policy_document.resource_full_access.json
  ]

  managed_policy_arns = [
    data.aws_iam_policy.readonly.arn
  ]
}
