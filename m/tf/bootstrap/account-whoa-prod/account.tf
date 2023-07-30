module "whoa-prod" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.whoa-prod
    }
}