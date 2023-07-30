module "spiral-net" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.spiral-net
    }
}