module "s3-helix-dev" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["helix-dev"]

  providers = {
    aws = aws.helix-dev
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}