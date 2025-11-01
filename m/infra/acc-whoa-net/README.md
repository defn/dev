# whoa-net Account Infrastructure

Account-specific Terraform configuration for the whoa organization's net account.

## Usage

```bash
cd infra/acc-whoa-net
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-whoa-net/terraform.tfstate`)
- **Profile**: `whoa-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
