module "coil-net" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.coil-net
    }
}