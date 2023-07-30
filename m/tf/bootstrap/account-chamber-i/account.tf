module "chamber-i" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.chamber-i
    }
}