module "imma-prod" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-prod
    }
}