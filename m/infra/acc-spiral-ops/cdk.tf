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
    key          = "stacks/acc-spiral-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "spiral-ops"
  alias   = "spiral-ops"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.spiral-ops
}

variable "config" {}

module "spiral-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "spiral"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.spiral-ops
  }

  config = var.config
}

output "auditor_arn" {
  value = module.spiral-ops.auditor_arn
}
