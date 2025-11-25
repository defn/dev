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
    key          = "stacks/acc-coil-hub/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "coil-hub"
  alias   = "coil-hub"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.coil-hub
}

variable "config" {}

module "coil-hub" {
  account   = 510430971399
  name      = "terraform"
  namespace = "coil"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.coil-hub
  }

  config = var.config
}

output "auditor_arn" {
  value = module.coil-hub.auditor_arn
}
