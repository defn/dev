build:
	cue eval --out json -e html | jq -r . > tutorial.html
	trunk fmt tutorial.*
