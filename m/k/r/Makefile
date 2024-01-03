# k/r is generated from c/r

release:
# remove ANYTHING: null
	(cd ../../c/r && cue export --out json -e cached_yaml) | jq -r 'to_entries[] | "\(.key) \(.value | @base64) 1"' | grep -v -e '^\s*[\w-]+: null\s*$$' | ../../c/release.py

release-digested:
# update image digests then release
	if env GIT_PAGER=cat git grep image:.[n]ot-found .; then $(MAKE) digest release; fi

digest:
	cd ../../c/r && $(MAKE) digest	