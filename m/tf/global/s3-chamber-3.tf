module "s3-chamber-3" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "chamber-3" ]

  providers = {
    aws = aws.chamber-3
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}