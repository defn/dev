#!/usr/bin/env bash

for a in *.template; do if test -r "$a"; then mv "${a}" "${a%.template}"; fi; done
git add .
git add -f .env
j build
git add tutorial.html
trunk fmt
code .
