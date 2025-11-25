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
    key          = "stacks/acc-spiral-log/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "spiral-log"
  alias   = "spiral-log"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.spiral-log
}

variable "config" {}

module "spiral-log" {
  account   = 510430971399
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-log
  }

  config = var.config
}

output "auditor_arn" {
  value = module.spiral-log.auditor_arn
}
