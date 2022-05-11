#!/usr/bin/env python

update_settings(max_parallel_updates = 6)

local_resource('proxy', cmd='bash -c "cd fly && ~/bin/e make proxy"', allow_parallel = True)
local_resource('trigger', cmd='bash -c "cd fly && ~/bin/e make trigger-docker"', allow_parallel = True)
local_resource('monitor', cmd='bash -c "~/bin/e make monitor"', allow_parallel = True)
local_resource('cicd', cmd='bash -c "time ~/bin/e make ci"', deps=['.test'], allow_parallel = True)
