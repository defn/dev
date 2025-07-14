# Go Command Structure

This directory contains the Go command-line interface structure and implementations.

## Files

- `BUILD.bazel` - Bazel build configuration for commands

## Subdirectories

- `api/` - API command implementation
- `gollm/` - LLM (Large Language Model) command implementation  
- `infra/` - Infrastructure command implementation
- `meh/` - Meh command directory
- `root/` - Root command implementation
- `tui/` - Text User Interface command implementation

## Purpose

Implements a modular CLI architecture using Go, where each subdirectory represents a different command or command group. This structure follows common Go CLI patterns like those used by Cobra and similar frameworks.

## Usage

Each subdirectory contains the implementation for a specific command, with shared build configuration managed at this level.