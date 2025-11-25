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
    key          = "stacks/acc-defn-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "defn-org"
  alias   = "defn-org"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.defn-org
}

variable "config" {}

module "defn-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "defn"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.defn-org
  }

  config = var.config
}

output "auditor_arn" {
  value = module.defn-org.auditor_arn
}
