module "s3-imma-org" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-org"]

  providers = {
    aws = aws.imma-org
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}