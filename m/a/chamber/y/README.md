# Chamber Environment: y

AWS environment configuration for chamber-y profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-y
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/y
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
