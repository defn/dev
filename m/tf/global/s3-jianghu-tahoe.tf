module "s3-jianghu-tahoe" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["jianghu-tahoe"]

  providers = {
    aws = aws.jianghu-tahoe
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}