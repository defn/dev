# Chamber Environment: f

AWS environment configuration for chamber-f profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-f
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/f
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
