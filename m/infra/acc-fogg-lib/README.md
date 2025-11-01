# fogg-lib Account Infrastructure

Account-specific Terraform configuration for the fogg organization's lib account.

## Usage

```bash
cd infra/acc-fogg-lib
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-lib/terraform.tfstate`)
- **Profile**: `fogg-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
