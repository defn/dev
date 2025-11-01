# fogg-net Account Infrastructure

Account-specific Terraform configuration for the fogg organization's net account.

## Usage

```bash
cd infra/acc-fogg-net
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-fogg-net/terraform.tfstate`)
- **Profile**: `fogg-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
