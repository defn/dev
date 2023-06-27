#!/usr/bin/env bash

set -efu

jq -r '.org | . as $org | keys[] | . as $o | $org[$o].account | keys[] | . as $member | "\($o)-\($org[$o].account[$member].account)"' <"$1"
