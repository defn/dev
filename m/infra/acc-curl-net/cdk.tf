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
    key          = "stacks/acc-curl-net/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "curl-net"
  alias   = "curl-net"
  region  = "us-east-1"
}

variable "config" {}

module "curl-net" {
  account   = 510430971399
  name      = "terraform"
  namespace = "curl"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.curl-net
  }

  config = var.config
}

output "auditor_arn" {
  value = module.curl-net.auditor_arn
}
