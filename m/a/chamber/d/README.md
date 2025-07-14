# Chamber Environment: d

AWS environment configuration for chamber-d profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-d
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/d
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
