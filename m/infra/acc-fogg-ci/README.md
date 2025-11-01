# fogg-ci Account Infrastructure

Account-specific Terraform configuration for the fogg organization's ci account.

## Usage

```bash
cd infra/acc-fogg-ci
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-ci/terraform.tfstate`)
- **Profile**: `fogg-ci`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
