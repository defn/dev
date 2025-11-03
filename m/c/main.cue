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

// Mapping of old Terraform resource names for migration
// Format: org: { account_key: "old_terraform_resource_name" }
_oldResourceNames: {
	chamber: {
		org: "chamber"
		"1": "defn_cd"
		"2": "defn_ci"
		"3": "defn_security"
		a: "defn_a"
		b: "defn_b"
		c: "defn_c"
		d: "defn_d"
		e: "defn_e"
		f: "defn_f"
		g: "defn_g"
		h: "defn_h"
		i: "defn_i"
		j: "defn_j"
		l: "defn_l"
		m: "defn_m"
		n: "defn_n"
		o: "defn_o"
		p: "defn_p"
		q: "defn_dev"
		r: "defn_r"
		s: "defn_s"
		t: "defn_t"
		u: "defn_qa"
		v: "defn_v"
		w: "defn_w"
		x: "defn_stage"
		y: "defn_prod"
		z: "defn_hub"
	}
	gyre: {
		org: "gyre"
		ops: "ops"
	}
	coil: {
		org: "coil"
		hub: "hub"
		lib: "lib"
		net: "net"
	}
	curl: {
		org: "curl"
		hub: "hub"
		lib: "lib"
		net: "net"
	}
	spiral: {
		org: "spiral"
		ci: "pub"
		dev: "dev"
		hub: "hub"
		lib: "lib"
		log: "log"
		net: "net"
		ops: "ops"
		prod: "sec"
		pub: "dmz"
	}
	helix: {
		org: "helix"
		ci: "sec"
		dev: "dev"
		hub: "hub"
		lib: "lib"
		log: "log"
		net: "net"
		ops: "ops"
		prod: "dmz"
		pub: "pub"
	}
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
				  name  = "\(accData.name)"\(strings.Join([
					if accData.iam_user_access_to_billing != _|_ {"\n\t\t  iam_user_access_to_billing = \"\(accData.iam_user_access_to_billing)\""},
					if accData.role_name != _|_ {"\n\t\t  role_name                  = \"\(accData.role_name)\""},
				], ""))
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
				strings.Join([for accKey, accData in orgData.account
					if _oldResourceNames[orgName] != _|_
					if _oldResourceNames[orgName][accKey] != _|_ {
					"""

				moved {
				  from = aws_organizations_account.\(_oldResourceNames[orgName][accKey])
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
