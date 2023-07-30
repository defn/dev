module "coil-lib" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.coil-lib
    }
}