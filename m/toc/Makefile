# Build tutorial HTML from CUE configuration
# Dependencies: cue command, jq command, CUE configuration files with html field
# Outputs: Generated tutorial.html file from CUE configuration
build:
	cue eval --out json -e html | jq -r . > tutorial.html
