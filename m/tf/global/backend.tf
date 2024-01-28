terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "dfn-defn-terraform-state"
    key            = "defn-org/global/terraform.tfstate"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = "true"
    profile        = "defn-org-sso"
  }
}