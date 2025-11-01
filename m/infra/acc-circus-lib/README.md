# circus-lib Account Infrastructure

Account-specific Terraform configuration for the circus organization's lib account.

## Usage

```bash
cd infra/acc-circus-lib
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-circus-lib/terraform.tfstate`)
- **Profile**: `circus-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
