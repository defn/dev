coder-agent *host:
	#!/usr/bin/env bash
  
	cd m && exec just coder::coder-agent {{host}} &

