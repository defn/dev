module "s3-spiral-net" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["spiral-net"]

  providers = {
    aws = aws.spiral-net
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}