<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_coder"></a> [coder](#provider\_coder) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_coder-login"></a> [coder-login](#module\_coder-login) | https://registry.coder.com/modules/coder-login | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_default_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_ec2_instance_state.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state) | resource |
| [aws_iam_instance_profile.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_secretsmanager_secret.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [coder_agent.main](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/agent) | resource |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app) | resource |
| [coder_metadata.main](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/metadata) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [coder_parameter.instance_type](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.nix_volume_size](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.prefix](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.provider](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.source_rev](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.workdir](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tsauthkey"></a> [tsauthkey](#input\_tsauthkey) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
