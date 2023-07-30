terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "dfn-defn-terraform-state"
    key            = "helix-lib/bootstrap/account-helix-lib/terraform.tfstate"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    profile        = "defn-org-sso"
    role_arn       = ""
    encrypt        = "true"
  }
}