# Jianghu AWS Organization

AWS SSO configuration for the jianghu organization.

## Usage

Activate an account environment:

```bash
cd a/jianghu/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 3 AWS account(s):

- `org/` - jianghu-org profile
- `log/` - jianghu-log profile
- `net/` - jianghu-net profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
