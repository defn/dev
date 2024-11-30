#!/usr/bin/env bash

for a in *.template; do if test -r "$a"; then mv "${a}" "${a%.template}"; fi; done
git add .
trunk fmt
direnv allow
j build
