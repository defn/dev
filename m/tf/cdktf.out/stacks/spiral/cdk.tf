terraform {
  required_providers {
    aws = {
      version = "5.21.0"
      source  = "aws"
    }
  }
  backend "s3" {
    bucket         = "dfn-defn-terraform-state"
    dynamodb_table = "dfn-defn-terraform-state-lock"
    encrypt        = undefined
    key            = "stacks/spiral/terraform.tfstate"
    profile        = "defn-org-sso"
    region         = "us-east-1"
  }


}

provider "aws" {
}
resource "aws_organizations_organization" "organization" {
}
data "aws_ssoadmin_instances" "sso_instance" {
}

locals {
  sso_instance_arn = "${data.aws_ssoadmin_instances.sso_instance.arns}"
}
resource "aws_ssoadmin_permission_set" "admin_sso_permission_set" {
}
resource "aws_ssoadmin_managed_policy_attachment" "admin_sso_managed_policy_attachment" {
}

locals {
  sso_instance_isid = "${data.aws_ssoadmin_instances.sso_instance.identity_store_ids}"
}
resource "aws_identitystore_group" "administrators_sso_group" {
}
resource "aws_organizations_account" "ops" {
}
resource "aws_ssoadmin_account_assignment" "ops_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "net" {
}
resource "aws_ssoadmin_account_assignment" "net_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "lib" {
}
resource "aws_ssoadmin_account_assignment" "lib_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "hub" {
}
resource "aws_ssoadmin_account_assignment" "hub_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "log" {
}
resource "aws_ssoadmin_account_assignment" "log_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "sec" {
}
resource "aws_ssoadmin_account_assignment" "sec_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "pub" {
}
resource "aws_ssoadmin_account_assignment" "pub_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "dev" {
}
resource "aws_ssoadmin_account_assignment" "dev_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "dmz" {
}
resource "aws_ssoadmin_account_assignment" "dmz_admin_sso_account_assignment" {
}
resource "aws_organizations_account" "spiral" {
}
resource "aws_ssoadmin_account_assignment" "spiral_admin_sso_account_assignment" {
}