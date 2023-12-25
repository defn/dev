module "chamber-5" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.chamber-5
  }
}