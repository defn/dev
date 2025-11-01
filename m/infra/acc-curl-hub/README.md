# curl-hub Account Infrastructure

Account-specific Terraform configuration for the curl organization's hub account.

## Usage

```bash
cd infra/acc-curl-hub
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-curl-hub/terraform.tfstate`)
- **Profile**: `curl-hub`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
