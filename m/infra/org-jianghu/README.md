# Jianghu Organization Infrastructure

Organization-level Terraform configuration for the jianghu AWS organization.

## Usage

```bash
cd infra/org-jianghu
mise trust
aws sso login
alogin
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-jianghu/terraform.tfstate`)
- **Profile**: `jianghu-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
