module "chamber-t" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.chamber-t
    }
}