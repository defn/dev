# Defn Fly.io Application

This directory contains the Defn application deployment configuration for Fly.io.

## Files

- `Dockerfile` - Container configuration for Defn application
- `Justfile` - Task runner with Defn-specific commands
- `fly.toml` - Fly.io deployment configuration

## Purpose

Provides containerized deployment configuration for the Defn application on the Fly.io platform.

## Usage

Use `just` commands to manage the application lifecycle, and `fly deploy` to deploy to Fly.io using the provided configuration.