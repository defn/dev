module "s3-coil-net" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["coil-net"]

  providers = {
    aws = aws.coil-net
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}