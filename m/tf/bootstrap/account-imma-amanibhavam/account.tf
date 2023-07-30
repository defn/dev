module "imma-amanibhavam" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-amanibhavam
    }
}