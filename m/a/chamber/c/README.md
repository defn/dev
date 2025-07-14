# Chamber Environment: c

AWS environment configuration for chamber-c profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-c
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/c
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
