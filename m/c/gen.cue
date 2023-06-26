package c

import (
	"encoding/yaml"
)

gen: "k": {
	for kname, k in kustomize {
		"\(kname)/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(k.out)

		for rname, r in k.resource {
			if r.kind != "" {
				"\(kname)/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
			}
		}

		for pname, p in k.psm {
			"\(kname)/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
		}
	}
}

gen: "e": {
	for ename, e in env {
		"\(e.env.metadata.name).yaml": "# ManagedBy: cue\n\n" + yaml.Marshal(e.env)
	}
}
