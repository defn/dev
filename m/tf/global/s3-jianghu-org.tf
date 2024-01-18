module "s3-jianghu-org" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["jianghu-org"]

  providers = {
    aws = aws.jianghu-org
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}