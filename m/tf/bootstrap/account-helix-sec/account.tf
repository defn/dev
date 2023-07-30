module "helix-sec" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.helix-sec
    }
}