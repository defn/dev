# Chamber Environment: x

AWS environment configuration for chamber-x profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-x
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/x
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
