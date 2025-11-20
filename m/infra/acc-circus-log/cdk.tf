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
    key          = "stacks/acc-circus-log/terraform.tfstate"
    profile      = "defn-org"
    region       = "us-east-1"
  }
}

provider "aws" {
  profile = "circus-log"
  alias   = "circus-log"
  region  = "us-east-1"
}

module "circus-log" {
  account   = 510430971399
  name      = "terraform"
  namespace = "circus"
  stage     = "ops"
  source    = "./mod/terraform-aws-defn-account"
  providers = {
    aws = aws.circus-log
  }
}

output "auditor_arn" {
  value = module.circus-log.auditor_arn
}
