terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "dfn-defn-terraform-state"
    key            = "fogg-sandbox/bootstrap/account-fogg-sandbox/terraform.tfstate"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    profile        = "defn-org-sso"
    encrypt        = "true"
  }
}