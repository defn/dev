# curl-lib Account Infrastructure

Account-specific Terraform configuration for the curl organization's lib account.

## Usage

```bash
cd infra/acc-curl-lib
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-curl-lib/terraform.tfstate`)
- **Profile**: `curl-lib`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
