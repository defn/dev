module "imma-dgwyn" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-dgwyn
    }
}