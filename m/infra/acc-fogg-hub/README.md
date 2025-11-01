# fogg-hub Account Infrastructure

Account-specific Terraform configuration for the fogg organization's hub account.

## Usage

```bash
cd infra/acc-fogg-hub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-hub/terraform.tfstate`)
- **Profile**: `fogg-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
