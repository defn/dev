# gyre-org Account Infrastructure

Account-specific Terraform configuration for the gyre organization's org account.

## Usage

```bash
cd infra/acc-gyre-org
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-gyre-org/terraform.tfstate`)
- **Profile**: `gyre-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
