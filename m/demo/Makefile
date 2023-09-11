build:
	cue eval --out json -e html | jq -r . | prettier --stdin-filepath tutorial.html > tutorial.html

tutorial:
	tilt up --stream