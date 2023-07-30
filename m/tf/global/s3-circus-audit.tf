module "s3-circus-audit" {
  source     = "../terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["circus-audit"]

  providers = {
    aws = aws.circus-audit
  }

  acl                = "private"
  user_enabled       = true
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules

  privileged_principal_arns    = local.privileged_principal_arns
  privileged_principal_actions = local.privileged_principal_actions
}