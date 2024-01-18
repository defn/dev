module "s3-curl-lib" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["curl-lib"]

  providers = {
    aws = aws.curl-lib
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}