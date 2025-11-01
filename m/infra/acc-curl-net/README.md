# curl-net Account Infrastructure

Account-specific Terraform configuration for the curl organization's net account.

## Usage

```bash
cd infra/acc-curl-net
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/acc-curl-net/terraform.tfstate`)
- **Profile**: `curl-net`
- **Provider**: AWS 5.99.1

## Resources

This directory manages account-specific resources and infrastructure.
