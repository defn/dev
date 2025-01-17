#!/usr/bin/env bash

set -e

source .bash_profile
cd m/i
source ~/work/.buildkite/.env
make latest
