build:
	time ((cd .. && b) | runmany 8 'bazel query "deps($$1)" --output graph > g$$(echo $$1 | tr :/ -).dot')

serve:
	 python3 -m http.server -d ../bazel-out/./k8-fastbuild/bin/graph