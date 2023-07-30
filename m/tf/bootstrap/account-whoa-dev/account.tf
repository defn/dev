module "whoa-dev" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.whoa-dev
    }
}