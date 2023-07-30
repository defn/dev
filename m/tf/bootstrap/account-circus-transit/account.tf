module "circus-transit" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.circus-transit
    }
}