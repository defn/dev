package c

import (
	"encoding/yaml"
	"strings"
)

lookup: {
	for ename, e in env {
		"\(ename)": {
			for kname, _ in e.bootstrap {
				if strings.HasPrefix(kname, "\(e.type)-\(ename)") {
					"\(kname)": kname
				}
				if !strings.HasPrefix(kname, "\(e.type)-\(ename)") {
					"\(kname)": "\(e.type)-\(ename)-\(kname)"
				}
			}
		}
	}
}

gen: "k": {
	for ename, e in env {
		let ekname = "\(e.type)-\(ename)"
		let ekmize = (( kustomize[ekname] ) & {cluster: domain_name: "bastard"})

		"\(ekname)/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(ekmize.out)

		for rname, r in ekmize.resource {
			if r.kind != "" {
				"\(ekname)/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
			}
		}

		for pname, p in ekmize.psm {
			"\(ekname)/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
		}

		for jname, j in ekmize.jsp {
			"\(ekname)/jsonp-\(jname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(j.patches)
		}

		for kname, _ in e.bootstrap {
			"\(lookup[ename][kname])/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(kustomize[kname].out)

			for rname, r in kustomize[kname].resource {
				if r.kind != "" {
					"\(lookup[ename][kname])/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
				}
			}

			for pname, p in kustomize[kname].psm {
				"\(lookup[ename][kname])/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
			}

			for jname, j in kustomize[kname].jsp {
				"\(lookup[ename][kname])/jsonp-\(jname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(j.patches)
			}
		}
	}
}

gen: "e": {
	for ename, e in env {
		"\(e.env.metadata.name).yaml": "# ManagedBy: cue\n\n" + yaml.Marshal(e.env)
	}
}
