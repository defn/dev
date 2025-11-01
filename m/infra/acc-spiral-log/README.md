# spiral-log Account Infrastructure

Account-specific Terraform configuration for the spiral organization's log account.

## Usage

```bash
cd infra/acc-spiral-log
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-log/terraform.tfstate`)
- **Profile**: `spiral-log`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
