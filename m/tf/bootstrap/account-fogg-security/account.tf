module "fogg-security" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.fogg-security
    }
}