# Database Utilities

This directory contains database utilities and tools using River job queue with SQLite.

## Overview

This application demonstrates River job queue functionality with SQLite database backend. The database is **automatically initialized** on first run - no manual setup required.

## Files

- `BUILD.bazel` - Bazel build configuration
- `TODO` - Task list and development notes
- `db.go` - Main Go application with River SQLite integration
- `mise.toml` - Development tool configurations

## SQLite Configuration

The application uses the following SQLite optimizations:

- **Database file**: `river.sqlite3` (created automatically in current directory)
- **WAL mode**: Enabled for better concurrency (allows concurrent reads during writes)
- **Immediate transactions**: Prevents deferred-transaction deadlocks (`_txlock=immediate`)
- **Single connection**: `SetMaxOpenConns(1)` to prevent SQLite write conflicts

## Automatic Initialization

When you run the application, it automatically:

1. Creates the SQLite database file if it doesn't exist
2. Enables WAL (Write-Ahead Logging) mode
3. Runs all River migrations to set up job queue tables
4. Starts the job worker and processes jobs

No manual migration steps required!

## Running

```bash
# Build and run
b run //db:db

# Or build first, then run
b build //db:db
bazel-bin/db/db_/db
```

The application will:

- Initialize the database automatically
- Insert a sample sort job
- Process the job with a worker
- Wait for SIGINT/SIGTERM to shutdown gracefully

## Performance Notes

River on SQLite achieves approximately **10k jobs/sec** on commodity hardware, about 25% of PostgreSQL performance. This is suitable for:

- Embedded applications
- Development/testing
- Single-server deployments
- Applications with moderate job throughput requirements

## RiverUI Limitation

**Important**: RiverUI (the web interface) does **not** currently support SQLite. It only works with PostgreSQL databases.

If you need the web UI, you have two options:

1. **Use PostgreSQL instead**: Change back to PostgreSQL if the web UI is required
2. **Skip the UI**: Use the River job queue with SQLite without the web interface

The River job queue itself works perfectly with SQLite - only the web UI is PostgreSQL-only.

## Manual Migration (Optional)

If you need to run migrations manually using the River CLI:

```bash
export DATABASE_URL="sqlite://./river.sqlite3"
river migrate-up --database-url "$DATABASE_URL"
```

Note: The `river` CLI tool supports SQLite for migrations, but `riverui` does not support SQLite for the web interface.
