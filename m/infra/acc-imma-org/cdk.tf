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
    key          = "stacks/acc-imma-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "imma-org"
  alias   = "imma-org"
  region  = "us-east-1"
}

module "imma-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "imma"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-org
  }
}

output "auditor_arn" {
  value = module.imma-org.auditor_arn
}
