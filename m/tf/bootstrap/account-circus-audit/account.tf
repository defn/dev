module "circus-audit" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.circus-audit
    }
}