module "jianghu-tahoe" {
  source  = "../../mod/terraform-aws-defn-account"
  context = module.this.context

  providers = {
    aws = aws.jianghu-tahoe
  }
}