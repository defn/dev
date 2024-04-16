create-coder-agent:
	#!/usr/bin/env bash

	#for p in $(pgrep -f just.coder::code.serve[r].$(uname -n) --older 30) $(pgrep -f just.coder::coder.agen[t].$(uname -n) --older 30); do
	for p in $(pgrep -f just.coder::code.serve[r].$(uname -n)); do
	  ps xf -o ppid,pgid | tail -n +2 | sed 's#^  *##g' | grep "^$p " | awk '{print $2}' | while read -r g; do 
	    kill -9 -$g
	  done
	done

	cd m
	just coder::coder-agent $(uname -n) 2>/dev/null 1>/dev/null &

