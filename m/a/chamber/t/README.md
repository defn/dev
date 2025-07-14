# Chamber Environment: t

AWS environment configuration for chamber-t profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-t
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/t
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
