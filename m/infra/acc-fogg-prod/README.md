# fogg-prod Account Infrastructure

Account-specific Terraform configuration for the fogg organization's prod account.

## Usage

```bash
cd infra/acc-fogg-prod
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-prod/terraform.tfstate`)
- **Profile**: `fogg-prod`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
