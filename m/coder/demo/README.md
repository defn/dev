---
name: Develop in Linux on AWS EC2
description: Get started with Linux development on AWS EC2.
tags: [cloud, aws]
icon: /icon/aws.png
---

# aws-linux

To get started, run `coder templates init`. When prompted, select this template.
Follow the on-screen instructions to proceed.

## Authentication

This template assumes that coderd is run in an environment that is authenticated
with AWS. For example, run `aws configure import` to import credentials on the
system and user running coderd. For other ways to authenticate [consult the
Terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration).

## Required permissions / policy

The following sample policy allows Coder to create EC2 instances and modify
instances provisioned by Coder:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "ec2:GetDefaultCreditSpecification",
        "ec2:DescribeIamInstanceProfileAssociations",
        "ec2:DescribeTags",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceTypes",
        "ec2:CreateTags",
        "ec2:RunInstances",
        "ec2:DescribeInstanceCreditSpecifications",
        "ec2:DescribeImages",
        "ec2:ModifyDefaultCreditSpecification",
        "ec2:DescribeVolumes"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CoderResources",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstanceAttribute",
        "ec2:UnmonitorInstances",
        "ec2:TerminateInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:DeleteTags",
        "ec2:MonitorInstances",
        "ec2:CreateTags",
        "ec2:RunInstances",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyInstanceCreditSpecification"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/Coder_Provisioned": "true"
        }
      }
    }
  ]
}
```

## code-server

`code-server` is installed via the `startup_script` argument in the `coder_agent`
resource block. The `coder_app` resource is defined to access `code-server` through
the dashboard UI over `localhost:13337`.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_coder"></a> [coder](#provider\_coder) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_instance_state.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state) | resource |
| [aws_instance.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [coder_agent.dev](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/agent) | resource |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app) | resource |
| [coder_metadata.workspace_info](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/metadata) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [coder_parameter.instance_type](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.region](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->