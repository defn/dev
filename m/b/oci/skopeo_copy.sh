#!/usr/bin/env bash

set -efuo pipefail

function main {
  local oci_in
  local repository

  local bhome
  bhome="$(pwd)"

  oci_in="${bhome}/$1"
  shift

  repository="$1"
  shift

  for t in "$@"; do
    skopeo copy "oci:${oci_in}" "docker://${repository}:${t}" --dest-tls-verify=false --insecure-policy
    docker pull "${repository}:${t}"
  done
}

main "$@"
