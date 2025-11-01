# Gyre AWS Organization

AWS SSO configuration for the gyre organization.

## Usage

Activate an account environment:

```bash
cd a/gyre/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 2 AWS account(s):

- `org/` - gyre-org profile
- `ops/` - gyre-ops profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
