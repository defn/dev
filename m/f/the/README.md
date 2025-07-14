# The Fly.io Application

This directory contains the The application deployment configuration for Fly.io.

## Files

- `Dockerfile` - Container configuration for The application
- `Justfile` - Task runner with The-specific commands
- `fly.toml` - Fly.io deployment configuration

## Purpose

Provides containerized deployment configuration for the The application on the Fly.io platform.

## Usage

Use `just` commands to manage the application lifecycle, and `fly deploy` to deploy to Fly.io using the provided configuration.