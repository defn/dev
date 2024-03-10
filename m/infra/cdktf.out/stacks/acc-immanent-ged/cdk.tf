terraform {
  required_providers {
    aws = {
      version = "5.38.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-immanent-ged/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "immanent-ged-sso"
  alias   = "immanent-ged"
}
module "immanent-ged" {
  account   = 767397818037
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "../../mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-ged
  }
}