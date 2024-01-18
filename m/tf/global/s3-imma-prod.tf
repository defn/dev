module "s3-imma-prod" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["imma-prod"]

  providers = {
    aws = aws.imma-prod
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}