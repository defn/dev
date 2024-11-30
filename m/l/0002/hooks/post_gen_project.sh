#!/usr/bin/env bash

for a in *.template; do mv "${a}" "${a%.template}"; done
