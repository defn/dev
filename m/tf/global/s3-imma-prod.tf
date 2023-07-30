module "s3-imma-prod" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-prod"]

  providers = {
    aws = aws.imma-prod
  }

  acl                = "private"
  user_enabled       = true
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}