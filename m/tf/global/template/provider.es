provider "aws" {
    alias = "${ACC_SLUG}"
    role_arn = "arn:aws:iam::${ACC_ID}:role/dfn-defn-terraform"
}