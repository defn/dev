g:
	time ((cd .. && b) | runmany 8 'bazel query "deps($$1)" --output graph > g$$(echo $$1 | tr :/ -).dot')