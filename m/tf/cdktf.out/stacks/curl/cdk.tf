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
    key            = "stacks/curl/terraform.tfstate"
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
resource "aws_organizations_account" "curl" {
}
resource "aws_ssoadmin_account_assignment" "curl_admin_sso_account_assignment" {
}