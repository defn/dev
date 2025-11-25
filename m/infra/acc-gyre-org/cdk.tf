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
    key          = "stacks/acc-gyre-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "gyre-org"
  alias   = "gyre-org"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.gyre-org
}

variable "config" {}

module "gyre-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "gyre"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.gyre-org
  }

  config = var.config
}

output "auditor_arn" {
  value = module.gyre-org.auditor_arn
}
