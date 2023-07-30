module "fogg-sandbox" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.fogg-sandbox
    }
}