module "s3-fogg-circus" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["fogg-circus"]

  providers = {
    aws = aws.fogg-circus
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}