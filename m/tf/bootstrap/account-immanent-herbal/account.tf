module "immanent-herbal" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-herbal
    }
}