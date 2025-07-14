# Brie Fly.io Application

This directory contains the Brie application deployment configuration for Fly.io.

## Files

- `Dockerfile` - Container configuration for Brie application
- `Justfile` - Task runner with Brie-specific commands
- `build.yaml` - Build configuration
- `entrypoint.sh` - Container entrypoint script
- `fly.toml` - Fly.io deployment configuration

## Purpose

Provides containerized deployment configuration for the Brie application on the Fly.io platform.

## Usage

Use `just` commands to manage the application lifecycle, and `fly deploy` to deploy to Fly.io using the provided configuration.