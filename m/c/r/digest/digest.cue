package r

import (
	"list"
	"strings"
)

image_digests: [
	for i, d in cache {
		"\(i) \(d)"
	},
]

except: {
	input: {...}
	exclude: string

	output: {
		for n in [ for n, _ in input {n}] {
			if n != exclude && (*input[n] | null) != null {
				"\(n)": *input[n] | null
			}
		}
	}
}

cached_resources: {
	for rname, r in resources
	if r.kind == "Deployment" || r.kind == "DaemonSet" || r.kind == "StatefulSet" || r.kind == "Job" || r.kind == "CronJob" {
		if len(*r.spec.template.spec.initContainers | []) > 0 {
			"\(rname)": {
				(except & {input: r, exclude: "spec"}).output
				spec: {
					(except & {input: r.spec, exclude: "template"}).output
					template: {
						(except & {input: r.spec.template, exclude: "spec"}).output
						spec: {
							(except & {input: r.spec.template.spec, exclude: "initContainers"}).output
							initContainers: [
								for c in r.spec.template.spec.initContainers {
									(except & {input: c, exclude: "image"}).output
									_parts: strings.Split(cache[c.image], "/")
									image:  "169.254.32.1:5000/\(strings.Join(list.Slice(_parts, 1, len(_parts)), "/"))"
								},
							]
						}
					}
				}
			}
		}
	}
}
