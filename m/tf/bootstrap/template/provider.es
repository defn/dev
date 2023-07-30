provider "aws" {
    alias = "${PROFILE}"
    profile = "${PROFILE}-sso"
}