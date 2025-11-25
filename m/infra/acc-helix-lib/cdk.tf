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
    key          = "stacks/acc-helix-lib/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "helix-lib"
  alias   = "helix-lib"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.helix-lib
}

variable "config" {}

module "helix-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "helix"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.helix-lib
  }

  config = var.config
}

output "auditor_arn" {
  value = module.helix-lib.auditor_arn
}
