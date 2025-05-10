#!/usr/bin/env bash

set -efuo pipefail

function main {
  local out
  local image
  local flake_earthly
  local earthfile
  local build_args

  local bhome
  bhome="$(pwd)"

  out="${bhome}/$1"
  shift

  image="$1"
  shift

  flake_earthly="${bhome}/$1"
  shift

  earthfile="$1"
  shift

  build_args="$1"
  shift

  local pth_build
  pth_build="$(mktemp -d -t XXXXXX)"

  cp -v "${earthfile}" "${pth_build}/"

  (
    set +f
    for i in "$@"; do
      if test -d "${i}"; then
        cp -v "${i}"/* "${pth_build}/"
      else
        cp -v "${i}" "${pth_build}/"
      fi
    done
  )

  if [[ $# == 0 ]]; then set -- --push -no-output +build; fi

  set -x

  cd "${pth_build}"
  # shellcheck disable=SC2086
  "${flake_earthly}" --build-arg "image=${image}" ${build_args} +build
  docker save "${image}" -o "${out}"

  rm -rf "${pth_build}"
}

main "$@"
