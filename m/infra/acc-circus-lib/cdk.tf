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
    key          = "stacks/acc-circus-lib/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "circus-lib"
  alias   = "circus-lib"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.circus-lib
}

variable "config" {}

module "circus-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "circus"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.circus-lib
  }

  config = var.config
}

output "auditor_arn" {
  value = module.circus-lib.auditor_arn
}
