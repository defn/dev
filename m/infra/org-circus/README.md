# Circus Organization Infrastructure

Organization-level Terraform configuration for the circus AWS organization.

## Usage

```bash
cd infra/org-circus
mise trust
aws sso login
terraform init
terraform plan
```

## Configuration

- **Backend**: S3 (`stacks/org-circus/terraform.tfstate`)
- **Profile**: `circus-org`
- **Provider**: AWS 5.99.1

## Resources

This directory manages organization-level resources:

- AWS Organizations structure
- AWS SSO configuration
- Cross-account IAM roles
- Organization-wide policies
