# spiral-org Account Infrastructure

Account-specific Terraform configuration for the spiral organization's org account.

## Usage

```bash
cd infra/acc-spiral-org
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-org/terraform.tfstate`)
- **Profile**: `spiral-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
