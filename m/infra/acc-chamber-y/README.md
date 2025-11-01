# chamber-y Account Infrastructure

Account-specific Terraform configuration for the chamber organization's y account.

## Usage

```bash
cd infra/acc-chamber-y
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-y/terraform.tfstate`)
- **Profile**: `chamber-y`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
