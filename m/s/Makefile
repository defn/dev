# Build tutorial HTML from CUE configuration and format files
# Dependencies: cue command, jq command, trunk command, CUE configuration files with html field
# Outputs: Generated tutorial.html file from CUE configuration, formatted tutorial.* files with trunk
build:
	cue eval --out json -e html | jq -r . > tutorial.html
	trunk fmt tutorial.*
