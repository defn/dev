<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws)       | 5.34.0  |
| <a name="requirement_coder"></a> [coder](#requirement_coder) | 0.13.0  |

## Providers

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)       | 5.34.0  |
| <a name="provider_coder"></a> [coder](#provider_coder) | 0.13.0  |

## Modules

| Name                                                                 | Source                                         | Version |
| -------------------------------------------------------------------- | ---------------------------------------------- | ------- |
| <a name="module_coder-login"></a> [coder-login](#module_coder-login) | https://registry.coder.com/modules/coder-login | n/a     |

## Resources

| Name                                                                                                                                          | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_default_vpc.default](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/default_vpc)                                      | resource    |
| [aws_ec2_instance_state.dev_21](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/ec2_instance_state)                         | resource    |
| [aws_iam_instance_profile.dev_16](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/iam_instance_profile)                     | resource    |
| [aws_iam_role.dev](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/iam_role)                                                | resource    |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/iam_role_policy_attachment)          | resource    |
| [aws_iam_role_policy_attachment.secretsmanager](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/iam_role_policy_attachment)            | resource    |
| [aws_instance.dev_17](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/instance)                                             | resource    |
| [aws_secretsmanager_secret.dev_18](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/secretsmanager_secret)                   | resource    |
| [aws_secretsmanager_secret_version.dev_19](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/secretsmanager_secret_version)   | resource    |
| [aws_security_group.dev_11](https://registry.terraform.io/providers/aws/5.34.0/docs/resources/security_group)                                 | resource    |
| [coder_agent.main](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/agent)                                           | resource    |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/app)                                        | resource    |
| [coder_metadata.main_20](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/resources/metadata)                                  | resource    |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/aws/5.34.0/docs/data-sources/ami)                                                    | data source |
| [coder_parameter.az](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                                  | data source |
| [coder_parameter.instance_type](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                       | data source |
| [coder_parameter.nix_volume_size](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                     | data source |
| [coder_parameter.provider](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                            | data source |
| [coder_parameter.region](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                              | data source |
| [coder_parameter.tsauthkey](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                           | data source |
| [coder_parameter.username](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/parameter)                            | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/0.13.0/docs/data-sources/workspace)                                  | data source |

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END_TF_DOCS -->
