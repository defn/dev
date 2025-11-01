# Whoa AWS Organization

AWS SSO configuration for the whoa organization.

## Usage

Activate an account environment:

```bash
cd a/whoa/ops
mise trust
aws sso login
aws sts get-caller-identity
```

## Accounts

This organization contains 5 AWS account(s):

- `dev/` - whoa-dev profile
- `hub/` - whoa-hub profile
- `net/` - whoa-net profile
- `org/` - whoa-org profile
- `pub/` - whoa-pub profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
