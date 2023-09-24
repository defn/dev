build:
	if cue eval --out json -e html >/dev/null; then cue eval --out json -e html | jq -r . > tutorial.html; fi
