module "s3-fogg-data" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["fogg-data"]

  providers = {
    aws = aws.fogg-data
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}