terraform {
  required_providers {
    aws = {
      version = "5.43.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "demonstrate-terraform-remote-state"
    dynamodb_table = "demonstrate-terraform-remote-state-lock"
    encrypt        = true
    key            = "stacks/acc-demo-net/terraform.tfstate"
    profile        = "demo-ops-sso"
    region         = "us-west-2"
  }

}

provider "aws" {
  profile = "demo-net-sso"
  alias   = "demo-net"
}

module "demo-net" {
  account   = 992382597334
  name      = "terraform"
  namespace = "demo"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.demo-net
  }
}
