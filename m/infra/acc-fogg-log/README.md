# fogg-log Account Infrastructure

Account-specific Terraform configuration for the fogg organization's log account.

## Usage

```bash
cd infra/acc-fogg-log
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-log/terraform.tfstate`)
- **Profile**: `fogg-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
