module "spiral-lib" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.spiral-lib
    }
}