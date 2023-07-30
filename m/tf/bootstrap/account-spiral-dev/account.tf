module "spiral-dev" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.spiral-dev
    }
}