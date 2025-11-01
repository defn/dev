# spiral-prod Account Infrastructure

Account-specific Terraform configuration for the spiral organization's prod account.

## Usage

```bash
cd infra/acc-spiral-prod
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-prod/terraform.tfstate`)
- **Profile**: `spiral-prod`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
