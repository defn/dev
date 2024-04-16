start-coder-agent *host:

coder-agent *host:
	#!/usr/bin/env bash
  
	for p in $(pgrep -f just.code.serve[r].$(uname -n)); do ps xf -o ppid,pgid,pid,cmd | grep '^\s*'"$p" | awk '{print $2}' | while read -r g; do kill -15 -$g; done; done
	for p in $(pgrep -f just.coder.agen[t].$(uname -n)); do ps xf -o ppid,pgid,pid,cmd | grep '^\s*'"$p" | awk '{print $2}' | while read -r g; do kill -15 -$g; done; done
	cd m && exec just coder::coder-agent {{host}} &
