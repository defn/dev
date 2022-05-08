#!/usr/bin/env python

local_resource('proxy', cmd='bash -c "cd fly && make login start-docker proxy"', allow_parallel = True)
local_resource('cicd', cmd='bash -c "time env DOCKER_HOST=localhost:2375 make ci"', deps=['.test'], allow_parallel = True)
