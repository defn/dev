module "helix-ops" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.helix-ops
    }
}