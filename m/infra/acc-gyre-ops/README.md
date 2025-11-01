# gyre-ops Account Infrastructure

Account-specific Terraform configuration for the gyre organization's ops account.

## Usage

```bash
cd infra/acc-gyre-ops
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-gyre-ops/terraform.tfstate`)
- **Profile**: `gyre-ops`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
