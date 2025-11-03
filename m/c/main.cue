@experiment(aliasv2)
@experiment(explicitopen)

package main

import (
	intention "github.com/defn/dev/m/c/intention"

	execution "github.com/defn/dev/m/c/execution"
	application "github.com/defn/dev/m/c/application"

	definition "github.com/defn/dev/m/c/definition"
	definition_aws "github.com/defn/dev/m/c/definition/aws"
)

import "strings"

// Base AWS unification
_awsBase: definition_aws & intention.aws

config: {
	resource: intention.resource
	resource: execution.resource

	repo: intention.repo
	repo: definition.repo
	repo: application.repo

	aws: _awsBase

	// Unify with generated org terraform
	aws: org: _orgTerraform
}

// Generate organization-level Terraform for each org
_orgTerraform: {
	for orgName, orgData in _awsBase.org {
		if orgData.account.org != _|_ {
			(orgName): account: org: infra_org_terraform: strings.Join([
				"""
			terraform {
			  required_providers {
			    aws = {
			      version = "5.99.1"
			      source  = "aws"
			    }
			  }
			  backend "s3" {
			    bucket         = "dfn-defn-terraform-state"
			    dynamodb_table = "dfn-defn-terraform-state-lock"
			    encrypt        = true
			    key            = "stacks/org-\(orgName)/terraform.tfstate"
			    profile        = "defn-org"
			    region         = "us-east-1"
			  }

			}

			locals {
			  sso_instance_arn  = data.aws_ssoadmin_instances.sso_instance.arns
			  sso_instance_isid = data.aws_ssoadmin_instances.sso_instance.identity_store_ids
			}

			provider "aws" {
			  profile = "\(orgName)-org"
			  region  = "\(orgData.sso_region)"
			}

			resource "aws_organizations_organization" "organization" {
			  aws_service_access_principals = [
			    "account.amazonaws.com",
			    "iam.amazonaws.com",
			    "cloudtrail.amazonaws.com",
			    "config.amazonaws.com",
			    "ram.amazonaws.com",
			    "ssm.amazonaws.com",
			    "sso.amazonaws.com",
			    "tagpolicies.tag.amazonaws.com"
			  ]
			  enabled_policy_types = [
			    "SERVICE_CONTROL_POLICY",
			    "TAG_POLICY"
			  ]
			  feature_set = "ALL"
			}

			data "aws_ssoadmin_instances" "sso_instance" {
			}

			resource "aws_ssoadmin_permission_set" "admin_sso_permission_set" {
			  instance_arn     = element(local.sso_instance_arn, 0)
			  name             = "Administrator"
			  session_duration = "PT2H"
			  tags = {
			    ManagedBy = "Terraform"
			  }
			}

			resource "aws_ssoadmin_managed_policy_attachment" "admin_sso_managed_policy_attachment" {
			  instance_arn       = aws_ssoadmin_permission_set.admin_sso_permission_set.instance_arn
			  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
			  permission_set_arn = aws_ssoadmin_permission_set.admin_sso_permission_set.arn
			}

			resource "aws_identitystore_group" "administrators_sso_group" {
			  display_name      = "Administrators"
			  identity_store_id = element(local.sso_instance_isid, 0)
			}
			""",
				strings.Join([for accKey, accData in orgData.account {
					"""

				resource "aws_organizations_account" "\(strings.Replace(accData.name, "-", "_", -1))" {
				  email = "\(accData.email)"
				  name  = "\(accData.name)"
				  tags = {
				    ManagedBy = "Terraform"
				  }
				}

				resource "aws_ssoadmin_account_assignment" "\(strings.Replace(accData.name, "-", "_", -1))_admin_sso_account_assignment" {
				  instance_arn       = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.instance_arn
				  permission_set_arn = aws_ssoadmin_managed_policy_attachment.admin_sso_managed_policy_attachment.permission_set_arn
				  principal_id       = aws_identitystore_group.administrators_sso_group.group_id
				  principal_type     = "GROUP"
				  target_id          = aws_organizations_account.\(strings.Replace(accData.name, "-", "_", -1)).id
				  target_type        = "AWS_ACCOUNT"
				}
				"""
				}], ""),
				strings.Join([for accKey, accData in orgData.account {
					"""

				moved {
				  from = aws_organizations_account.\(orgName)-\(accKey)
				  to   = aws_organizations_account.\(strings.Replace(accData.name, "-", "_", -1))
				}
				"""
				}], ""),
				strings.Join([for accKey, accData in orgData.account if strings.Contains(accData.name, "-") {
					"""

				moved {
				  from = aws_ssoadmin_account_assignment.\(accData.name)_admin_sso_account_assignment
				  to   = aws_ssoadmin_account_assignment.\(strings.Replace(accData.name, "-", "_", -1))_admin_sso_account_assignment
				}
				"""
				}], ""),
			], "")
		}
	}
}
