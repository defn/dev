# fogg-pub Account Infrastructure

Account-specific Terraform configuration for the fogg organization's pub account.

## Usage

```bash
cd infra/acc-fogg-pub
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-pub/terraform.tfstate`)
- **Profile**: `fogg-pub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
