module "chamber-n" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.chamber-n
    }
}