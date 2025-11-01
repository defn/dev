# imma-org Account Infrastructure

Account-specific Terraform configuration for the imma organization's org account.

## Usage

```bash
cd infra/acc-imma-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-org/terraform.tfstate`)
- **Profile**: `imma-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
