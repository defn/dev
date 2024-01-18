module "s3-coil-hub" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["coil-hub"]

  providers = {
    aws = aws.coil-hub
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}