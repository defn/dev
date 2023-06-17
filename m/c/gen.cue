package c

import (
	"encoding/yaml"
)

gen: "kustomize": {
	for kname, k in kustomize {
		"../k/\(kname)/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(k.out)

		for rname, r in k.resource {
			if r.kind != "" {
				"../k/\(kname)/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
			}
		}

		for pname, p in k.psm {
			"../k/\(kname)/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
		}
	}
}

gen: "env": {
	for ename, e in env {
		"../e/\(e.env.metadata.name).yaml": "# ManagedBy: cue\n\n" + yaml.Marshal(e.env)
	}
}
