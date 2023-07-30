module "fogg-post" {
    source = "../../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.fogg-post
    }
}