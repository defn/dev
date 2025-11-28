#!/usr/bin/env bash

set -e

source .bash_profile
source ~/work/.buildkite/.env
cd m
mise install
b build
b test
