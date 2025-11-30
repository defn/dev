#!/usr/bin/env bash
# Test script for bashel examples
set -euo pipefail

# In Bazel tests, files are in the runfiles directory
# For target //bashel:test, files are under bashel/
RUNFILES_DIR="${TEST_SRCDIR:-$PWD}"

echo "Checking generated outputs..."
ls -lh "$RUNFILES_DIR/_main/bashel/reports/app_size.txt"
ls -lh "$RUNFILES_DIR/_main/bashel/normalized/app.conf"
ls -lh "$RUNFILES_DIR/_main/bashel/normalized/database.conf"
ls -lh "$RUNFILES_DIR/_main/bashel/normalized/cache.conf"
ls -lh "$RUNFILES_DIR/_main/bashel/production_config_bundle.tar.gz"
ls -lh "$RUNFILES_DIR/_main/bashel/staging_config_bundle.tar.gz"
ls -lh "$RUNFILES_DIR/_main/bashel/production_bundle_info.txt"
ls -lh "$RUNFILES_DIR/_main/bashel/staging_bundle_info.txt"

echo ""
echo "Checking script dependencies..."
ls -lh "$RUNFILES_DIR/_main/bashel/ex-genrule/scripts/uppercase.sh"
ls -lh "$RUNFILES_DIR/_main/bashel/ex-genrule/scripts/word_count.sh"
ls -lh "$RUNFILES_DIR/_main/bashel/ex-macros/scripts/create_archive.sh"
ls -lh "$RUNFILES_DIR/_main/bashel/ex-macros/scripts/list_archive.sh"

echo ""
echo "Checking build configuration..."
ls -lh "$RUNFILES_DIR/_main/bashel/bazel/bazel.cue"

echo ""
echo "All dependencies verified!"
