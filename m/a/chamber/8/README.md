# Chamber Environment: 8

AWS environment configuration for chamber-8 profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-8
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/8
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
