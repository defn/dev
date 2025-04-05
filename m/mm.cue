package m

#file: {
    type: "file"
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

_mise_toml: #file & {
    covered: true
	tool: mise: {}
}

#aws_account: {
    "mise.toml"!: _mise_toml
}

files: {
    [=~"^/a/\\w+/\\w+$"]: #aws_account

    [DIR=string]: [=~"^mise.toml$"]: _mise_toml
}
