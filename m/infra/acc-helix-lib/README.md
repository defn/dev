# helix-lib Account Infrastructure

Account-specific Terraform configuration for the helix organization's lib account.

## Usage

```bash
cd infra/acc-helix-lib
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-lib/terraform.tfstate`)
- **Profile**: `helix-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
