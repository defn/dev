module "s3-spiral-sec" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-sec"]

  providers = {
    aws = aws.spiral-sec
  }

  acl                = "private"
  user_enabled       = true
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}