# jianghu-org Account Infrastructure

Account-specific Terraform configuration for the jianghu organization's org account.

## Usage

```bash
cd infra/acc-jianghu-org
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-jianghu-org/terraform.tfstate`)
- **Profile**: `jianghu-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
