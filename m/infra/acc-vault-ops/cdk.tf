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
    key          = "stacks/acc-vault-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-ops"
  alias   = "vault-ops"
  region  = "us-east-1"
}

module "vault-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-ops
  }
}

output "auditor_arn" {
  value = module.vault-ops.auditor_arn
}
