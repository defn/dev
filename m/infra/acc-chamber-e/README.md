# chamber-e Account Infrastructure

Account-specific Terraform configuration for the chamber organization's e account.

## Usage

```bash
cd infra/acc-chamber-e
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-e/terraform.tfstate`)
- **Profile**: `chamber-e`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
