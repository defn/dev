terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = true
    key            = "stacks/acc-jianghu-net/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "jianghu-net"
  region  = "us-east-1"
  alias   = "jianghu-net"
}

module "jianghu-net" {
  account   = 510430971399
  name      = "terraform"
  namespace = "jianghu"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.jianghu-net
  }
}
