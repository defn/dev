module "s3-imma-dev" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-dev"]

  providers = {
    aws = aws.imma-dev
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}