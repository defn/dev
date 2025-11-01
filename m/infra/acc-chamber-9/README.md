# chamber-9 Account Infrastructure

Account-specific Terraform configuration for the chamber organization's 9 account.

## Usage

```bash
cd infra/acc-chamber-9
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-9/terraform.tfstate`)
- **Profile**: `chamber-9`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
