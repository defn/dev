provider "aws" {
  profile = "defn-org-sso"
  region  = "us-east-1"
  alias = "chamber-1"
  assume_role {
    role_arn = "arn:aws:iam::741346472057:role/dfn-defn-terraform"
  }
}