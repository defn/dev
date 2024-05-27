terraform {
  required_providers {

  }
  backend "s3" {
    bucket         =
    dynamodb_table =
    encrypt        = true
    key            = "stacks/global/terraform.tfstate"
    profile        =
    region         =
  }


}