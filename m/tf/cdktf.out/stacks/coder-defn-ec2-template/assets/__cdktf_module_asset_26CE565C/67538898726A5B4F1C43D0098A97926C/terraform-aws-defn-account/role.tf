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
    AWS = ["arn:aws:iam::510430971399:root"]
  }

  policy_documents = [
    data.aws_iam_policy_document.resource_full_access.json
  ]
}