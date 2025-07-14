# Chamber Environment: r

AWS environment configuration for chamber-r profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-r
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/r
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
