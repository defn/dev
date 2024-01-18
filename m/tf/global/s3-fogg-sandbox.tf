module "s3-fogg-sandbox" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["fogg-sandbox"]

  providers = {
    aws = aws.fogg-sandbox
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}