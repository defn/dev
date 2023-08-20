<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                            | n/a     |
| <a name="provider_coder"></a> [coder](#provider_coder)                      | n/a     |
| <a name="provider_digitalocean"></a> [digitalocean](#provider_digitalocean) | n/a     |
| <a name="provider_docker"></a> [docker](#provider_docker)                   | n/a     |
| <a name="provider_fly"></a> [fly](#provider_fly)                            | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                         | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_default_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc)                           | resource    |
| [aws_ec2_instance_state.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_state)                 | resource    |
| [aws_iam_instance_profile.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)             | resource    |
| [aws_iam_role.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_instance.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                     | resource    |
| [aws_security_group.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                         | resource    |
| [coder_agent.main](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/agent)                                          | resource    |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                       | resource    |
| [coder_app.docs](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                              | resource    |
| [coder_app.storybook](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                         | resource    |
| [coder_app.tilt](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                              | resource    |
| [coder_app.web](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                               | resource    |
| [digitalocean_droplet.workspace](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet)            | resource    |
| [digitalocean_volume.nix_volume](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume)             | resource    |
| [docker_container.workspace](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container)                     | resource    |
| [docker_image.main](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image)                                  | resource    |
| [fly_app.workspace](https://registry.terraform.io/providers/fly-apps/fly/latest/docs/resources/app)                                          | resource    |
| [fly_machine.workspace](https://registry.terraform.io/providers/fly-apps/fly/latest/docs/resources/machine)                                  | resource    |
| [fly_volume.nix_volume](https://registry.terraform.io/providers/fly-apps/fly/latest/docs/resources/volume)                                   | resource    |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                         | data source |
| [coder_parameter.cpu](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                                | data source |
| [coder_parameter.docker_image](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                       | data source |
| [coder_parameter.memory](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                             | data source |
| [coder_parameter.nix_volume_size](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                    | data source |
| [coder_parameter.provider](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                           | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace)                                 | data source |

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END_TF_DOCS -->
