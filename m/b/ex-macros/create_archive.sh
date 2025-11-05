#!/usr/bin/env bash

# Creates a tarball from files
function main {
    local prefix="${in[prefix]:-archive}"
    local out="${shome}/${out}"

    local tmp_dir="$(mktemp -d)"
    trap "rm -rf ${tmp_dir}" EXIT

    # Create prefix directory
    mkdir -p "${tmp_dir}/${prefix}"

    # Copy all files passed as arguments
    for file in "${args[@]}"; do
        cp "${file}" "${tmp_dir}/${prefix}/"
    done

    # Create tarball
    tar czf "${out}" -C "${tmp_dir}" .
}

source b/lib/lib.sh
