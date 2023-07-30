module "curl-lib" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.curl-lib
    }
}