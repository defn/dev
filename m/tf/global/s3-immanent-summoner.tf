module "s3-immanent-summoner" {
  source     = "../mod/terraform-aws-s3-bucket"
  context    = module.this.context
  attributes = ["immanent-summoner"]

  providers = {
    aws = aws.immanent-summoner
  }

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  lifecycle_configuration_rules = local.lifecycle_configuration_rules
}