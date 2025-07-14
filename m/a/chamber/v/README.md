# Chamber Environment: v

AWS environment configuration for chamber-v profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-v
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/v
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
