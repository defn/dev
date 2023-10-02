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
	exclude: {[string]: bool}

	output: {
		for n in [ for n, _ in input {n}] {
			if exclude[n] == _|_ && input[n] != _|_ {
				"\(n)": *input[n] | _|_
			}
		}
	}
}

cached_image: {
	c: {...}
	output: {
		(except & {input: c, exclude: {image: true}}).output

		if cache[c.image] != _|_ {
			_parts: strings.Split(cache[c.image], "/")
			image:  "169.254.32.1:5000/\(strings.Join(list.Slice(_parts, 1, len(_parts)), "/"))"
		}
		if cache[c.image] == _|_ {
			image: c.image
		}
	}
}

uncached_resources: {
	for rname, r in resources {
		"\(rname)": r
	}
}

cached_resources: {
	for rname, r in resources {
		"\(rname)": {
			(except & {input: r, exclude: {spec: true}}).output
			if r.spec != _|_ {
				spec: {
					(except & {input: r.spec, exclude: {template: true}}).output
					if r.spec.template != _|_ {
						template: {
							(except & {input: r.spec.template, exclude: {spec: true}}).output
							if r.spec.template.spec != _|_ {
								spec: {
									(except & {input: r.spec.template.spec, exclude: {containers: true, initContainers: true}}).output
									if r.spec.template.spec.initContainers != _|_ {
										initContainers: [
											for c in r.spec.template.spec.initContainers {
												(cached_image & {"c": c}).output
											},
										]
									}
									if r.spec.template.spec.containers != _|_ {
										containers: [
											for c in r.spec.template.spec.containers {
												(cached_image & {"c": c}).output
											},
										]
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
