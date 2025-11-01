# circus-log Account Infrastructure

Account-specific Terraform configuration for the circus organization's log account.

## Usage

```bash
cd infra/acc-circus-log
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-circus-log/terraform.tfstate`)
- **Profile**: `circus-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
