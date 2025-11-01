# helix-org Account Infrastructure

Account-specific Terraform configuration for the helix organization's org account.

## Usage

```bash
cd infra/acc-helix-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-org/terraform.tfstate`)
- **Profile**: `helix-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
