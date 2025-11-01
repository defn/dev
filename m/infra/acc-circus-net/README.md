# circus-net Account Infrastructure

Account-specific Terraform configuration for the circus organization's net account.

## Usage

```bash
cd infra/acc-circus-net
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-circus-net/terraform.tfstate`)
- **Profile**: `circus-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
