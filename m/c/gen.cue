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

		for jname, j in k.jsp {
			"\(kname)/jsonp-\(jname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(j.patches)
		}
	}

	for ename, e in env {
		for kname, _ in e.bootstrap {
			"\(e.type)-\(ename)-\(kname)/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(kustomize[kname].out)

			for rname, r in kustomize[kname].resource {
				if r.kind != "" {
					"\(e.type)-\(ename)-\(kname)/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
				}
			}

			for pname, p in kustomize[kname].psm {
				"\(e.type)-\(ename)-\(kname)/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
			}

			for jname, j in kustomize[kname].jsp {
				"\(e.type)-\(ename)-\(kname)/jsonp-\(jname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(j.patches)
			}
		}
	}
}

gen: "e": {
	for ename, e in env {
		"\(e.env.metadata.name).yaml": "# ManagedBy: cue\n\n" + yaml.Marshal(e.env)
	}
}
