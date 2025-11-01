# chamber-l Account Infrastructure

Account-specific Terraform configuration for the chamber organization's l account.

## Usage

```bash
cd infra/acc-chamber-l
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-chamber-l/terraform.tfstate`)
- **Profile**: `chamber-l`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
