# circus-org Account Infrastructure

Account-specific Terraform configuration for the circus organization's org account.

## Usage

```bash
cd infra/acc-circus-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-circus-org/terraform.tfstate`)
- **Profile**: `circus-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
