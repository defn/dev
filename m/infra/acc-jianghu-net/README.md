# jianghu-net Account Infrastructure

Account-specific Terraform configuration for the jianghu organization's net account.

## Usage

```bash
cd infra/acc-jianghu-net
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-jianghu-net/terraform.tfstate`)
- **Profile**: `jianghu-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
