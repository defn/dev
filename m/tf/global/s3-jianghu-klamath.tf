module "s3-jianghu-klamath" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["jianghu-klamath"]

  providers = {
    aws = aws.jianghu-klamath
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}