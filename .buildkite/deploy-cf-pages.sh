#!/usr/bin/env bash

set -exu pipefail

shome="$(pwd)"
source ~/.bash_profile
$shome/bin/invoke m install
$shome/bin/invoke m package

