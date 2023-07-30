module "gyre-ops" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.gyre-ops
    }
}