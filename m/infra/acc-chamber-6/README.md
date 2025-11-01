# chamber-6 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 6 account.

## Usage

```bash
cd infra/acc-chamber-6
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-6/terraform.tfstate`)
- **Profile**: `chamber-6`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
