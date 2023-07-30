provider "aws" {
  alias = "${ACC_SLUG}"
  assume_role {
    role_arn = "arn:aws:iam::${ACC_ID}:role/dfn-defn-terraform"
  }
}
