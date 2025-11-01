# spiral-net Account Infrastructure

Account-specific Terraform configuration for the spiral organization's net account.

## Usage

```bash
cd infra/acc-spiral-net
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-spiral-net/terraform.tfstate`)
- **Profile**: `spiral-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
