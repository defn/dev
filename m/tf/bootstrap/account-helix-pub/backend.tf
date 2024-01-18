terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "dfn-defn-terraform-state"
    key            = "helix-pub/bootstrap/account-helix-pub/terraform.tfstate"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    profile        = "defn-org-sso"
    encrypt        = "true"
  }
}