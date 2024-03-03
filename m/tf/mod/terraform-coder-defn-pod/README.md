<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_coder"></a> [coder](#provider\_coder) | 0.11.2 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [coder_agent.main](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/agent) | resource |
| [coder_app.code-server](https://registry.terraform.io/providers/coder/coder/latest/docs/resources/app) | resource |
| [helm_release.main](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role_binding.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_deployment.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_namespace.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [coder_parameter.cpu](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.docker_image](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.memory](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.nix_volume_size](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.provider](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.source_rev](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_parameter.workdir](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/parameter) | data source |
| [coder_workspace.me](https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
