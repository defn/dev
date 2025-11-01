# chamber-u Account Infrastructure

Account-specific Terraform configuration for the chamber organization's u account.

## Usage

```bash
cd infra/acc-chamber-u
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-u/terraform.tfstate`)
- **Profile**: `chamber-u`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
