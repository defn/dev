terraform {
  required_providers {
    aws = {
      version = "5.34.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-immanent-hand/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
  profile = "immanent-hand-sso"
  alias   = "immanent-hand"
}
module "immanent-hand" {
  name      = "terraform"
  namespace = "dfn"
  stage     = "defn"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-hand
  }
}