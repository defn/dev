# Chamber Environment: h

AWS environment configuration for chamber-h profile.

## Configuration

This directory contains mise.toml with:
- AWS Profile: chamber-h
- AWS Region: us-west-2
- SSO authentication hook

## Usage

```bash
cd m/a/chamber/h
# AWS profile automatically activated via mise
aws sts get-caller-identity
```
