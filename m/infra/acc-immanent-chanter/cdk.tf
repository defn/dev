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
    key            = "stacks/acc-immanent-chanter/terraform.tfstate"
    profile        = "defn-org"
    region         = "us-east-1"
  }

}

provider "aws" {
  profile = "immanent-chanter"
  region  = "us-east-1"
  alias   = "immanent-chanter"
}

module "immanent-chanter" {
  account   = 510430971399
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-chanter
  }
}
