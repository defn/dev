#!/usr/bin/env bash

set -e

source .bash_profile
trunk check --ci || true
