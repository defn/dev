module "chamber-x" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.chamber-x
    }
}