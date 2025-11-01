# Circus AWS Organization

AWS SSO configuration for the circus organization.

## Usage

Activate an account environment:

```bash
cd a/circus/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 5 AWS account(s):

- `lib/` - circus-lib profile
- `log/` - circus-log profile
- `net/` - circus-net profile
- `ops/` - circus-ops profile
- `org/` - circus-org profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
