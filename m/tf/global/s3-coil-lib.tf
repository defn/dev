module "s3-coil-lib" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["coil-lib"]

  providers = {
    aws = aws.coil-lib
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}