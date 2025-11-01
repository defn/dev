# imma-lib Account Infrastructure

Account-specific Terraform configuration for the imma organization's lib account.

## Usage

```bash
cd infra/acc-imma-lib
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-imma-lib/terraform.tfstate`)
- **Profile**: `imma-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
