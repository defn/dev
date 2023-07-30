module "s3-chamber-2" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["chamber-2"]

  providers = {
    aws = aws.chamber-2
  }

  acl                = "private"
  user_enabled       = true
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}