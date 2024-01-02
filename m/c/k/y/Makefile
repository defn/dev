cluster_cue:
	(echo package y; for r in ../../../k/y/*/main.yaml; do \
		echo cue import $$r 1>&2; \
		(cue import $$r -p y --with-context \
			-l '"res"' -l 'strings.ToLower(data.kind)' -l 'path.Dir(path.Rel("$(shell cd ../../../k/y && pwd)",filename))' -l 'strings.ToLower(*data.metadata.namespace | "cluster")' -l data.metadata.name --outfile - \
		| perl -pe 's{^\s*\w+:\s+null\s*}{}') > $$(basename $$(dirname $$r)).cue; done)