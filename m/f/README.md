# Fly.io Deployment Configurations

This directory contains Fly.io deployment configurations and Docker setups for various applications.

## Files

- `Justfile` - Task runner configuration
- `mise.toml` - Development tool configuration

## Subdirectories

- `brie/` - Brie application deployment configuration
- `defn/` - Defn application deployment configuration  
- `so/` - So application deployment configuration
- `the/` - The application deployment configuration

Each subdirectory contains:
- `Dockerfile` - Container configuration
- `Justfile` - Application-specific tasks
- `fly.toml` - Fly.io deployment configuration