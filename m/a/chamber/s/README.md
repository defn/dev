# Chamber Environment: s

AWS environment configuration for chamber-s profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-s
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/s
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
