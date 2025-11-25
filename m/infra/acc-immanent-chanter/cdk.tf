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
    key          = "stacks/acc-immanent-chanter/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "immanent-chanter"
  alias   = "immanent-chanter"
  region  = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.immanent-chanter
}

variable "config" {}

module "immanent-chanter" {
  account   = 510430971399
  name      = "terraform"
  namespace = "immanent"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.immanent-chanter
  }

  config = var.config
}

output "auditor_arn" {
  value = module.immanent-chanter.auditor_arn
}
