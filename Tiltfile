#!/usr/bin/env python

update_settings(max_parallel_updates = 6)

local_resource('proxy', cmd='bash -c "cd fly && exec ~/bin/e make proxy-docker"', allow_parallel = True)
local_resource('socat', cmd='bash -c "cd fly && exec ~/bin/e make socat-docker"', allow_parallel = True)
