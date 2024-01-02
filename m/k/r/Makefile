release:
# remove ANYTHING: null
	(cd ../../c/r && cue export --out json -e cached_yaml) | jq -r 'to_entries[] | "\(.key) \(.value | @base64) 1"' | grep -v -e '^\s*[\w-]+: null\s*$$' | ../../c/release.py