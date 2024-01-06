package k

import (
	"list"
	"strings"
	"encoding/yaml"
)

image_digests: [
	for i, d in cache {
		"\(i) \(d)"
	},
]

except: {
	input: {...}
	exclude: {[string]: bool}

	output: {
		for n in [ for n, _ in input {n}] {
			if exclude[n] == _|_ && input[n] != _|_ {
				(n): *input[n] | _|_
			}
		}
	}
}

cached_image: {
	c: {...}
	output: {
		(except & {input: c, exclude: {image: true}}).output

		if cache[c.image] != _|_ {
			image: "cache.defn.run:5000/\(cache[c.image])"
		}
		if cache[c.image] == _|_ {
			image: "\(c.image)"
		}
	}
}

uncached_resources: {
	for fname, f in resources
	for rname, r in f {
		(fname): (rname): r
	}
}

cache: [string]: string

cached_yaml: {
	for fname, f in cached_resources {
		"\(fname)/main.yaml": yaml.MarshalStream([ for s in list.SortStrings([ for rname, r in f {rname}]) {f[s]}])
	}
}

cached_resources: {
	for fname, f in resources
	for rname, r in f {
		(fname): (rname): {
			(except & {input: r, exclude: {rules: true, spec: true}}).output

			// rules:
			if r.rules != _|_ {
				if len(r.rules) > 0 {
					rules: r.rules
				}
			}

			// spec:
			if r.spec != _|_ {spec: {
				(except & {input: r.spec, exclude: {image: true, containers: true, jobTemplate: true, template: true}}).output

				// spec: image
				if r.spec.image != _|_ {image: {
					if cache[r.spec.image] != _|_ {
						_parts: strings.Split(cache[r.spec.image], "/")
						"cache.defn.run:5000/\(strings.Join(list.Slice(_parts, 1, len(_parts)), "/"))"
					}
					if cache[r.spec.image] == _|_ {
						"not-found-\(r.spec.image)"
					}
				}}

				// spec: containers
				if r.spec.containers != _|_ {containers: [
					for c in r.spec.containers {
						(cached_image & {"c": c}).output
					},
				]}

				// spec: jobTemplate
				if r.spec.jobTemplate != _|_ {jobTemplate: {
					(except & {input: r.spec.jobTemplate, exclude: {spec: true}}).output

					// spec: jobTemplate: spec
					if r.spec.jobTemplate.spec != _|_ {spec: {
						(except & {input: r.spec.jobTemplate.spec, exclude: {template: true}}).output

						// spec: jobTemplate: spec: template
						if r.spec.jobTemplate.spec.template != _|_ {template: {
							(except & {input: r.spec.jobTemplate.spec.template, exclude: {spec: true}}).output

							// spec: jobTemplate: spec: template: spec 
							if r.spec.jobTemplate.spec.template.spec != _|_ {spec: {
								(except & {input: r.spec.jobTemplate.spec.template.spec, exclude: {containers: true, initContainers: true}}).output

								// spec: jobTemplate: spec: template: spec: initContainers
								if r.spec.jobTemplate.spec.template.spec.initContainers != _|_ {initContainers: [
									for c in r.spec.jobTemplate.spec.tempate.spec.initContainers {
										(cached_image & {"c": c}).output
									},
								]}

								// spec: jobTemplate: spec: template: spec: containers
								if r.spec.jobTemplate.spec.template.spec.containers != _|_ {containers: [
									for c in r.spec.jobTemplate.spec.template.spec.containers {
										(cached_image & {"c": c}).output
									},
								]}
							}}
						}}
					}}
				}}

				// spec: template
				if r.spec.template != _|_ {template: {
					(except & {input: r.spec.template, exclude: {spec: true}}).output

					// spec: template: spec
					if r.spec.template.spec != _|_ {spec: {
						(except & {input: r.spec.template.spec, exclude: {containers: true, initContainers: true}}).output

						// spec: template: spec: initContainers
						if r.spec.template.spec.initContainers != _|_ {initContainers: [
							for c in r.spec.template.spec.initContainers {
								(cached_image & {"c": c}).output
							},
						]}

						// spec: template: spec: containers
						if r.spec.template.spec.containers != _|_ {containers: [
							for c in r.spec.template.spec.containers {
								(cached_image & {"c": c}).output
							},
						]}
					}}
				}}
			}}
		}
	}
}
