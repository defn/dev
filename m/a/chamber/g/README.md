# Chamber Environment: g

AWS environment configuration for chamber-g profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-g
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/g
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
