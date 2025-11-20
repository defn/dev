# auto-generated: aws.cue infra_acc_terraform
terraform {
  required_providers {
    aws = {
      version = "5.99.1"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket       = "dfn-defn-terraform-state"
    use_lockfile = true
    encrypt      = true
    key          = "stacks/acc-spiral-lib/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "spiral-lib"
  alias   = "spiral-lib"
  region  = "us-east-1"
}

module "spiral-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-lib
  }
}

output "auditor_arn" {
  value = module.spiral-lib.auditor_arn
}
