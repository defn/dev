terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "dfn-defn-terraform-state"
    key            = "fogg-hub/bootstrap/account-fogg-hub/terraform.tfstate"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    profile        = "defn-org-sso"
    role_arn       = ""
    encrypt        = "true"
  }
}