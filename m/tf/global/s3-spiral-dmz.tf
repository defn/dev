module "s3-spiral-dmz" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-dmz"]

  providers = {
    aws = aws.spiral-dmz
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}