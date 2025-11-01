# chamber-j Account Infrastructure

Account-specific Terraform configuration for the chamber organization's j account.

## Usage

```bash
cd infra/acc-chamber-j
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-j/terraform.tfstate`)
- **Profile**: `chamber-j`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
