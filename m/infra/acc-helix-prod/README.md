# helix-prod Account Infrastructure

Account-specific Terraform configuration for the helix organization's prod account.

## Usage

```bash
cd infra/acc-helix-prod
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-helix-prod/terraform.tfstate`)
- **Profile**: `helix-prod`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
