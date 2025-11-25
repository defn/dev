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
    key          = "stacks/acc-imma-lib/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "imma-lib"
  alias   = "imma-lib"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.imma-lib
}

variable "config" {}

module "imma-lib" {
  account   = 510430971399
  name      = "terraform"
  namespace = "imma"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.imma-lib
  }

  config = var.config
}

output "auditor_arn" {
  value = module.imma-lib.auditor_arn
}
