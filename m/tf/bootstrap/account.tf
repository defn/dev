module "chamber-1" {
  source  = "../terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.chamber-1
  }
}

module "chamber-2" {
  source  = "../terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.chamber-2
  }
}

