module "s3-spiral-lib" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-lib"]

  providers = {
    aws = aws.spiral-lib
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}