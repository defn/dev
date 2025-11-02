# Meh Command

This directory contains the meh command implementation for querying AWS resources across regions.

## Files

- `BUILD.bazel` - Bazel build configuration
- `meh.go` - Meh command implementation

## Purpose

Queries AWS EC2 instances and EBS volumes across multiple AWS regions in parallel. The command:

- Automatically discovers all AWS regions if none are specified
- Queries EC2 instances and EBS volumes concurrently with throttling
- Aggregates results into a structured JSON output
- Provides interactive debugging on errors

This is a Go implementation of the bash script originally in `a/.mise/tasks/meh`.

## Usage

```bash
# Query all regions
m meh

# Query specific regions
m meh us-east-1 us-west-2 eu-west-1
```

## Output Format

Results are output as JSON with the following structure:

```json
{
  "aws": {
    "us-east-1": {
      "ec2-instance": {
        "i-1234567890abcdef0": { /* instance data */ }
      },
      "volume": {
        "vol-1234567890abcdef0": { /* volume data */ }
      }
    }
  }
}
```

## Features

- **Parallel execution**: Queries multiple regions concurrently with configurable throttling
- **Automatic region discovery**: Uses AWS API to find all available regions
- **Error handling**: Drops into interactive shell on merge errors for debugging
- **Structured output**: Organizes results by region and resource type
