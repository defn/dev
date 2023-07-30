module "s3-coil-hub" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["coil-hub"]

  providers = {
    aws = aws.coil-hub
  }

  acl                = "private"
  user_enabled       = true
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}