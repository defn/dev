@experiment(aliasv2)
@experiment(explicitopen)

package m

#file: {
	type:    "file"
	covered: bool | *false
	...
}

uncovered: {
	for dname, d in files
	for fname, f in d
	if !f.covered {
		"\(dname)/\(fname)": {}
	}
}

#mise_toml: #file & {
	covered: true
	tool: mise: {}
}

#aws_account: {
	"mise.toml"!: #mise_toml
}

files: {
	[=~"^/a/\\w+/\\w+$"]: #aws_account

	[string]: [=~"^mise.toml$"]: #mise_toml
}
