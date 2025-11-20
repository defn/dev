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
    key          = "stacks/acc-gyre-ops/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "gyre-ops"
  alias   = "gyre-ops"
  region  = "us-east-1"
}

module "gyre-ops" {
  account   = 510430971399
  name      = "terraform"
  namespace = "gyre"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.gyre-ops
  }
}

output "auditor_arn" {
  value = module.gyre-ops.auditor_arn
}
