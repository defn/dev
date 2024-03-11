terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region  = "us-west-2"
    bucket  = "demonstrate-terraform-remote-state"
    key     = "terraform.tfstate"
    profile = "demo-ops-sso"
    encrypt = "true"

    dynamodb_table = "demonstrate-terraform-remote-state-lock"
  }
}
