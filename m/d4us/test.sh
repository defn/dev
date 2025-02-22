#!/usr/bin/env bash

# This is a bash script file.  Run the script file with `./test.sh` in the shell`

# testing is a bash function
function testing {
	# test function runs these commands
	cue eval
	cue fmt .
}

# something has to run, so lets start with testing
testing
