# fogg-org Account Infrastructure

Account-specific Terraform configuration for the fogg organization's org account.

## Usage

```bash
cd infra/acc-fogg-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-org/terraform.tfstate`)
- **Profile**: `fogg-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
