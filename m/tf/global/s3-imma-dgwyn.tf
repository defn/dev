module "s3-imma-dgwyn" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-dgwyn"]

  providers = {
    aws = aws.imma-dgwyn
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}