module "defn-org" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.defn-org
    }
}