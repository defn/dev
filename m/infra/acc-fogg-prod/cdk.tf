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
    key          = "stacks/acc-fogg-prod/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "fogg-prod"
  alias   = "fogg-prod"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.fogg-prod
}

variable "config" {}

module "fogg-prod" {
  account   = 510430971399
  name      = "terraform"
  namespace = "fogg"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.fogg-prod
  }

  config = var.config
}

output "auditor_arn" {
  value = module.fogg-prod.auditor_arn
}
