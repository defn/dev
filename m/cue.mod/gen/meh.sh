#!/usr/bin/env bash

function main {
	cat "${in[config]}" | jq >"${out}"
}

source b/lib/lib.sh
