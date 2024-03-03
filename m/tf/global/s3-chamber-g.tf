module "s3-chamber-g" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = [ "chamber-g" ]

  providers = {
    aws = aws.chamber-g
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}