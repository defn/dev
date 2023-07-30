module "s3-circus-transit" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "circus-transit" ]

  providers = {
    aws = aws.circus-transit
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}