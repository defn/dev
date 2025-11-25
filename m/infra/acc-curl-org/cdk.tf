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
    key          = "stacks/acc-curl-org/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "curl-org"
  alias   = "curl-org"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.curl-org
}

variable "config" {}

module "curl-org" {
  account   = 510430971399
  name      = "terraform"
  namespace = "curl"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.curl-org
  }

  config = var.config
}

output "auditor_arn" {
  value = module.curl-org.auditor_arn
}
