module "s3-spiral-ops" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-ops"]

  providers = {
    aws = aws.spiral-ops
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}