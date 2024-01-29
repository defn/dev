terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = "true"
    key            = "defn-org/global/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }
}