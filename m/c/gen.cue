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

#FSKustomize: {
	ekname: string
	ekmize: #KustomizeHelm | #Kustomize

	output: {
		for rname, r in ekmize.resource {
			if r.kind != "" {
				"\(ekname)/resource-\(rname).yaml": yaml.Marshal(r)
			}
		}

		for pname, p in ekmize.psm {
			"\(ekname)/patch-\(pname).yaml": yaml.Marshal(p)
		}

		for jname, j in ekmize.jsp {
			"\(ekname)/jsonp-\(jname).yaml": yaml.Marshal(j.patches)
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
			"\(lookup[input.ename][kname])/kustomization.yaml": yaml.Marshal((kustomize[kname] & {cluster: input.cluster}).out)

			(#FSKustomize & {
				ekname: lookup[input.ename][kname]
				ekmize: (kustomize[kname] & {cluster: input.cluster})
			}).output
		}
	}
}

gen: "k": {
	for ename, e in env {
		// environment app names are suffixed with -env
		let ekname = "\(ename)-env"
		let ekmize = kustomize[ekname]

		"\(ekname)/kustomization.yaml": yaml.Marshal(ekmize.out)

		(#FSKustomize & {
			"ekname": ekname
			"ekmize": ekmize
		}).output

		(#ConcreteKustomize & {input: {
			"ename":   ename
			bootstrap: e.bootstrap
			cluster:   infra[ename]
		}}).output
	}
}

gen: "e": {
	for ename, e in env {
		"\(e.env.metadata.name).yaml": yaml.Marshal(e.env)
	}
}
