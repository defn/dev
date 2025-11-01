# jianghu-log Account Infrastructure

Account-specific Terraform configuration for the jianghu organization's log account.

## Usage

```bash
cd infra/acc-jianghu-log
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-jianghu-log/terraform.tfstate`)
- **Profile**: `jianghu-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
