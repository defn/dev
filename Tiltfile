#!/usr/bin/env python

 update_settings (max_parallel_updates = 4)

local_resource('proxy', cmd='bash -c "cd fly && make login start-docker proxy"', allow_parallel = True)
local_resource('ping', cmd='bash -c "cd fly && make ping-docker"', allow_parallel = True)
local_resource('tunnel', cmd='bash -c "cd fly && make tunnel-docker"', allow_parallel = True)
local_resource('cicd', cmd='bash -c "time env DOCKER_HOST=localhost:2375 make ci"', deps=['.test'], allow_parallel = True)
