# bin/

This directory contains executable scripts and utilities used throughout the project.

## Contents

### Shell Scripts
- **b** - Interactive Bazel wrapper with fuzzy search support
- **bazel** - Wrapper script that executes bazelisk  
- **browser** - Cross-platform web browser launcher
- **code** - VSCode/code-server launcher wrapper
- **j** - Just command runner wrapper with interactive selection
- **k** - kubectl wrapper with config profile support
- **mark** - Display styled text using gum or echo as fallback
- **runmany** - Run commands in parallel with xargs
- **t** - Tracing wrapper for commands with Honeycomb integration
- **with-env** - Execute commands with bash profile environment

### Utilities
- **defn** - Project-specific utility script
- **talign** - Text alignment utility (Perl script)
- **tolan** - Text processing utility

### Configuration
- **.gitignore** - Git ignore rules for this directory

All scripts are executable and documented with usage information. Most scripts include dependencies and output documentation in their header comments.