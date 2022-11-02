#!/usr/bin/env bash

source $stdenv/setup

buildPhase() {
    declare -xp
    find . -ls
}

installPhase() {
  mkdir -p $out/bin
  cp tilt $out/bin
}

genericBuild
