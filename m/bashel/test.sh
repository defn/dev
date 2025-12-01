#!/usr/bin/env bash

set -euo pipefail

echo "Checking generated outputs..."
ls -lh "$TEST_SRCDIR/_main/bashel/reports/app_size.txt"
ls -lh "$TEST_SRCDIR/_main/bashel/normalized/app.conf"
ls -lh "$TEST_SRCDIR/_main/bashel/normalized/database.conf"
ls -lh "$TEST_SRCDIR/_main/bashel/normalized/cache.conf"
ls -lh "$TEST_SRCDIR/_main/bashel/production_config_bundle.tar.gz"
ls -lh "$TEST_SRCDIR/_main/bashel/staging_config_bundle.tar.gz"
ls -lh "$TEST_SRCDIR/_main/bashel/production_bundle_info.txt"
ls -lh "$TEST_SRCDIR/_main/bashel/staging_bundle_info.txt"

echo ""
echo "Checking script dependencies..."
ls -lh "$TEST_SRCDIR/_main/bashel/ex-genrule/scripts/uppercase.sh"
ls -lh "$TEST_SRCDIR/_main/bashel/ex-genrule/scripts/word_count.sh"
ls -lh "$TEST_SRCDIR/_main/bashel/ex-macros/scripts/create_archive.sh"
ls -lh "$TEST_SRCDIR/_main/bashel/ex-macros/scripts/list_archive.sh"

echo ""
echo "Checking build configuration..."
ls -lh "$TEST_SRCDIR/_main/bashel/bazel/bazel.cue"

echo ""
echo "All dependencies verified!"
