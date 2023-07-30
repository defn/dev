module "s3-chamber-t" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "chamber-t" ]

  providers = {
    aws = aws.chamber-t
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}