module "immanent-ged" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-ged
    }
}