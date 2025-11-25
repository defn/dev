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
    key          = "stacks/acc-vault-hub/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "vault-hub"
  alias   = "vault-hub"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.vault-hub
}

variable "config" {}

module "vault-hub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "vault"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.vault-hub
  }

  config = var.config
}

output "auditor_arn" {
  value = module.vault-hub.auditor_arn
}
