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
    key          = "stacks/acc-vault-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-org"
  alias   = "vault-org"
  region  = "us-east-1"
}

module "vault-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-org
  }
}

output "auditor_arn" {
  value = module.vault-org.auditor_arn
}
