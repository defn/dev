module "s3-spiral-dev" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-dev"]

  providers = {
    aws = aws.spiral-dev
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}