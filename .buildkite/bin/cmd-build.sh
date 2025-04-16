#!/usr/bin/env bash

set -e

cd ~/m/cmd

source ~/.bash_profile

for a in darwin linux; do for b in amd64 arm64; do
	echo $a $b
	GOOS=$a GOARCH=$b go build -o defn-$a-$b
done; done
