<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_coder"></a> [coder](#provider_coder)                | n/a     |
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                  | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [coder_agent.main](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/agent)                                                   | resource    |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app)                                                | resource    |
| [kubernetes_deployment.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment)                           | resource    |
| [kubernetes_persistent_volume_claim.home](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource    |
| [coder_parameter.cpu](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                                         | data source |
| [coder_parameter.docker_image](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                                | data source |
| [coder_parameter.memory](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                                      | data source |
| [coder_parameter.nix_volume_size](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                             | data source |
| [coder_parameter.provider](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter)                                    | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace)                                          | data source |

## Inputs

| Name                                                         | Description                                                                                | Type     | Default | Required |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | -------- | ------- | :------: |
| <a name="input_namespace"></a> [namespace](#input_namespace) | The Kubernetes namespace to create workspaces in (must exist prior to creating workspaces) | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
