module "whoa-secrets" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.whoa-secrets
    }
}