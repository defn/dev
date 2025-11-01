# whoa-hub Account Infrastructure

Account-specific Terraform configuration for the whoa organization's hub account.

## Usage

```bash
cd infra/acc-whoa-hub
mise trust
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-whoa-hub/terraform.tfstate`)
- **Profile**: `whoa-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
