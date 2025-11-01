# Immanent AWS Organization

AWS SSO configuration for the immanent organization.

## Usage

Activate an account environment:

```bash
cd a/immanent/ops
mise trust
aws sso login
alogin
aws sts get-caller-identity
```

## Accounts

This organization contains 12 AWS account(s):

- `changer/` - immanent-changer profile
- `chanter/` - immanent-chanter profile
- `doorkeeper/` - immanent-doorkeeper profile
- `ged/` - immanent-ged profile
- `hand/` - immanent-hand profile
- `herbal/` - immanent-herbal profile
- `namer/` - immanent-namer profile
- `org/` - immanent-org profile
- `patterner/` - immanent-patterner profile
- `roke/` - immanent-roke profile
- `summoner/` - immanent-summoner profile
- `windkey/` - immanent-windkey profile

## Structure

Each account directory contains:

- `mise.toml` - Sets AWS_PROFILE, AWS_REGION, and AWS_CONFIG_FILE
- `.aws/config` - AWS SSO profile configuration

## Generated Files

All configuration files are auto-generated from `c/definition/aws/aws.cue`. Do not edit manually.
