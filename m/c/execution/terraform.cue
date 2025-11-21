@experiment(aliasv2)
@experiment(explicitopen)

package execution

import (
	"strings"
	"list"
)

// Terraform configuration for output aggregation
// This receives aws and bootstrap configuration from the parent config
terraform: {
	// These will be unified with values from config
	bootstrap: {
		org:     string
		account: string
		profile: string
		bucket:  string
	}

	// Receive just the parts we need from aws (no underscore so it exports to YAML)
	aws_orgs: [string]: {
		account: [string]: {...}
		...
	}

	// Backend configuration
	backend: {
		type: "s3"
		config: {
			bucket:       bootstrap.bucket
			use_lockfile: true
			encrypt:      true
			key:          "stacks/output/terraform.tfstate"
			profile:      bootstrap.profile
			region:       "us-east-1"
		}
	}

	// Provider configuration
	provider: aws: {
		profile: bootstrap.profile
		alias:   bootstrap.profile
		region:  "us-east-1"
	}

	// Required providers
	required_providers: aws: {
		version: "5.99.1"
		source:  "aws"
	}

	// Generate the complete main.tf content
	main_tf: """
terraform {
  required_providers {
    aws = {
      version = "\(required_providers.aws.version)"
      source  = "\(required_providers.aws.source)"
    }
  }
  backend "s3" {
    bucket       = "\(backend.config.bucket)"
    use_lockfile = \(backend.config.use_lockfile)
    encrypt      = \(backend.config.encrypt)
    key          = "\(backend.config.key)"
    profile      = "\(backend.config.profile)"
    region       = "\(backend.config.region)"
  }
}

provider "aws" {
  profile = "\(provider.aws.profile)"
  alias   = "\(provider.aws.alias)"
  region  = "\(provider.aws.region)"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "\(bootstrap.bucket)"
    key    = "stacks/global/terraform.tfstate"
    region = "us-east-1"
  }
}

\(strings.Join(_org_states, "\n"))

\(strings.Join(_acc_states, "\n"))

output "all" {
  value = {
    "global" : data.terraform_remote_state.global.outputs
\(strings.Join(_output_refs, "\n"))
  }
}

"""

	// Generate org-level remote states
	_org_states: [...string]
	_org_states: list.Concat([
		for org_name, org_data in aws_orgs
		for acc_name, acc_data in org_data.account
		if acc_name == "org" {
			[
				"""
				data "terraform_remote_state" "org_\(org_name)" {
				  backend = "s3"
				  config = {
				    bucket = "\(bootstrap.bucket)"
				    key    = "stacks/org-\(org_name)/terraform.tfstate"
				    region = "us-east-1"
				  }
				}
				""",
			]
		},
	])

	// Generate account-level remote states
	_acc_states: [...string]
	_acc_states: list.Concat([
		for org_name, org_data in aws_orgs
		for acc_name, acc_data in org_data.account {
			[
				"""
				data "terraform_remote_state" "acc_\(org_name)_\(acc_name)" {
				  backend = "s3"
				  config = {
				    bucket = "\(bootstrap.bucket)"
				    key    = "stacks/acc-\(org_name)-\(acc_name)/terraform.tfstate"
				    region = "us-east-1"
				  }
				}
				""",
			]
		},
	])

	// Generate output references
	_output_refs: [...string]
	_output_refs: list.Concat([
		// Org outputs
		[
			for org_name, org_data in aws_orgs
			for acc_name, acc_data in org_data.account
			if acc_name == "org" {
				"    \"org-\(org_name)\" : data.terraform_remote_state.org_\(org_name).outputs"
			},
		],
		// Account outputs
		[
			for org_name, org_data in aws_orgs
			for acc_name, acc_data in org_data.account {
				"    \"acc-\(org_name)-\(acc_name)\" : data.terraform_remote_state.acc_\(org_name)_\(acc_name).outputs"
			},
		],
	])
}
