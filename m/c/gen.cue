package c

import (
	"encoding/yaml"
)

infra: [string]: #Cluster

lookup: {
	for ename, e in env {
		(ename): {
			for kname, _ in e.bootstrap {
				(kname): "\(ename)-\(kname)"
			}
		}
	}
}

#ConcreteKustomize: {
	input: {
		ename: string
		bootstrap: {...}
		cluster: #Cluster
	}

	output: {
		for kname, _ in input.bootstrap
		if kname !~ "env$" {
			"\(lookup[input.ename][kname])/kustomization.yaml": "#ManagedBy: cue\n\n" + yaml.Marshal((kustomize[kname] & {cluster: input.cluster}).out)

			for rname, r in (kustomize[kname] & {cluster: input.cluster}).resource {
				if r.kind != "" {
					"\(lookup[input.ename][kname])/resource-\(rname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(r)
				}
			}

			for pname, p in (kustomize[kname] & {cluster: input.cluster}).psm {
				"\(lookup[input.ename][kname])/patch-\(pname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(p)
			}

			for jname, j in (kustomize[kname] & {cluster: input.cluster}).jsp {
				"\(lookup[input.ename][kname])/jsonp-\(jname).yaml": "#ManagedBy: cue\n\n" + yaml.Marshal(j.patches)
			}
		}
	}
}

gen: "k": {
	for ename, e in env {
		// environment app names are suffixed with -env
		let ekname = "\(ename)-env"
		let ekmize = kustomize[ekname]

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

		(#ConcreteKustomize & {input: {
			"ename":   ename
			bootstrap: e.bootstrap
			cluster:   infra[ename]
		}}).output
	}
}

gen: "e": {
	for ename, e in env {
		"\(e.env.metadata.name).yaml": "# ManagedBy: cue\n\n" + yaml.Marshal(e.env)
	}
}
