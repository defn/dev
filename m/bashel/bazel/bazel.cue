// bazel.cue
// Bazel build generation engine: schemas, renderers, and transformation logic

package bazel

import ( "strings"

	// ---------------- Schema ----------------
)

#Label: string & =~"^(:|//).+" // Bazel-ish labels

// Input type for normalize field (nested map: source label -> output path -> index)
#InputNormalize: {
	[#Label]: [string]: int
}

// ----------------- Renderers ------------------

#q: {
	#in: string
	out: "\"\(#in)\""
}

renderLoad: {
	#in: {
		kind: "load"
		bzl:  string
		symbols: [...string]
	}
	_syms: [for s in #in.symbols {"\"\(s)\""}]
	_symsJoined: strings.Join(_syms, ", ")
	out:         "load(\"\(#in.bzl)\", \(_symsJoined))"
}

renderList: {
	#in: [...string]
	_items: [for s in #in {"        \"\(s)\",\n"}]
	_joined: strings.Join(_items, "")
	out:     "[\n\(_joined)    ]"
}

renderLabelList: {
	#in: [...string]
	_items: [for s in #in {"        \"\(s)\",\n"}]
	_joined: strings.Join(_items, "")
	out:     "[\n\(_joined)    ]"
}

renderGenrule: {
	#in: {
		name: string
		outs: [...string]
		cmd: string
		srcs?: [...string]
		tools?: [...string]
		...
	}

	_outsItems: [for s in #in.outs {"        \"\(s)\",\n"}]
	_outsJoined: strings.Join(_outsItems, "")
	_outsList:   "[\n\(_outsJoined)    ]"

	_hasSrcs:  #in.srcs != _|_
	_hasTools: #in.tools != _|_

	_srcsItems: *[] | [...string]
	if _hasSrcs {
		_srcsItems: [for s in #in.srcs {"        \"\(s)\",\n"}]
	}
	_srcsJoined: strings.Join(_srcsItems, "")
	_srcsList:   "[\n\(_srcsJoined)    ]"

	_toolsItems: *[] | [...string]
	if _hasTools {
		_toolsItems: [for s in #in.tools {"        \"\(s)\",\n"}]
	}
	_toolsJoined: strings.Join(_toolsItems, "")
	_toolsList:   "[\n\(_toolsJoined)    ]"

	_srcsLine: *"" | string
	if _hasSrcs {
		_srcsLine: "    srcs = \(_srcsList),\n"
	}

	_toolsLine: *"" | string
	if _hasTools {
		_toolsLine: "    tools = \(_toolsList),\n"
	}

	out: """
genrule(
  name = "\(#in.name)",
  \(_srcsLine)
  outs = \(_outsList),
  cmd = \"\"\"
\(#in.cmd)
\"\"\",
\(_toolsLine))
"""
}

renderFilegroup: {
	#in: {
		name: string
		srcs: [...string]
		...
	}
	_srcsItems: [for s in #in.srcs {"        \"\(s)\",\n"}]
	_srcsJoined: strings.Join(_srcsItems, "")
	_srcsList:   "[\n\(_srcsJoined)    ]"
	out:         """
filegroup(
  name = "\(#in.name)",
  srcs = \(_srcsList),
)
"""
}

renderArchiveDir: {
	#in: {
		name:   string
		dir:    string
		prefix: string
		...
	}
	out: """
archive_directory(
  name = "\(#in.name)",
  dir = "\(#in.dir)",
  prefix = "\(#in.prefix)",
)
"""
}

renderArchiveInfo: {
	#in: {
		name:    string
		archive: string
		...
	}
	out: """
archive_info(
  name = "\(#in.name)",
  archive = "\(#in.archive)",
)
"""
}

renderShTest: {
	#in: {
		name: string
		srcs: [...string]
		data: [...string]
		...
	}
	_srcsItems: [for s in #in.srcs {"        \"\(s)\",\n"}]
	_srcsJoined: strings.Join(_srcsItems, "")
	_srcsList:   "[\n\(_srcsJoined)    ]"

	_dataItems: [for d in #in.data {"        \"\(d)\",\n"}]
	_dataJoined: strings.Join(_dataItems, "")
	_dataList:   "[\n\(_dataJoined)    ]"

	out: """
sh_test(
  name = "\(#in.name)",
  srcs = \(_srcsList),
  data = \(_dataList),
)
"""
}

// ----------------- Build Generator ------------------

// Input type that accepts maps (closed structs with concrete keys)
#InputNormalize: {
	[#Label]: [string]: int
}

#BuildGenerator: {
	#in: {
		tool: {
			uppercase: string
			wordcount: string
			lib:       string
		}
		load: {[string]: [...string]}
		raw_config: {[string]: {path: string, content: string}}
		normalize: #InputNormalize
		size_report: {[string]: {src: string, out: string}}
		bundle: {[string]: {srcs: string | [...string], prefix: string}}
		info: {[string]: {archive: string}}
		filegroup: {[string]: {srcs: [...string]}}
		test: {[string]: {src: string, data: [...string]}}
	}

	// Renderer map
	_render: {
		"load":                    renderLoad
		"genrule":                 renderGenrule
		"filegroup":               renderFilegroup
		"macro.archive_directory": renderArchiveDir
		"macro.archive_info":      renderArchiveInfo
		"sh_test":                 renderShTest
	}

	// Templates - render loads directly since they come from a map
	_rendered_load: [
		for bzl, symbols in #in.load {
			_syms: [for s in symbols {"\"\(s)\""}]
			_symsJoined: strings.Join(_syms, ", ")
			out:         "load(\"\(bzl)\", \(_symsJoined))"
		},
	]

	_t_raw: {
		kind: "genrule"
		name: "raw_configs"
		outs: [for _, f in #in.raw_config {f.path}]
		_echos: [for _, f in #in.raw_config {"echo '\(f.content)' > $(@D)/\(f.path)"}]
		_echosJoined: strings.Join(_echos, "\n")
		cmd:          """
mkdir -p $(@D)/raw
\(_echosJoined)
"""
	}

	// Render normalize genrules directly
	_rendered_norm: [
		for from, outputs in #in.normalize
		for outPath, index in outputs {
			_nameBase: strings.Replace(strings.Replace(outPath, "/", "_", -1), ".", "_", -1)
			_srcsItems: ["        \"\(from)\",\n"]
			_srcsList: "[\n" + strings.Join(_srcsItems, "") + "    ]"
			_outsItems: ["        \"\(outPath)\",\n"]
			_outsList: "[\n" + strings.Join(_outsItems, "") + "    ]"
			_toolsItems: [
				"        \"\(#in.tool.uppercase)\",\n",
				"        \"\(#in.tool.lib)\",\n",
			]
			_toolsList: "[\n" + strings.Join(_toolsItems, "") + "    ]"
			_cmd:       "set -- $(locations \(from))\n$(location \(#in.tool.uppercase)) input=$$\(index) $@"
			out:        "genrule(\n  name = \"\(_nameBase)\",\n    srcs = \(_srcsList),\n  outs = \(_outsList),\n  cmd = \"\"\"\n\(_cmd)\n\"\"\",\n    tools = \(_toolsList),\n)"
		},
	]

	// Collect normalized target names for filegroup
	_norm_names: [
		for from, outputs in #in.normalize
		for outPath, _ in outputs {
			":" + strings.Replace(strings.Replace(outPath, "/", "_", -1), ".", "_", -1)
		},
	]

	_t_norm_group: {
		kind: "filegroup"
		name: "normalized_configs"
		srcs: _norm_names
	}

	// Render size_report directly
	_rendered_size_report: [
		for name, r in #in.size_report {
			_srcsItems: ["        \"\(r.src)\",\n"]
			_srcsList: "[\n" + strings.Join(_srcsItems, "") + "    ]"
			_outsItems: ["        \"\(r.out)\",\n"]
			_outsList: "[\n" + strings.Join(_outsItems, "") + "    ]"
			_toolsItems: [
				"        \"\(#in.tool.wordcount)\",\n",
				"        \"\(#in.tool.lib)\",\n",
			]
			_toolsList: "[\n" + strings.Join(_toolsItems, "") + "    ]"
			_cmd:       "$(location \(#in.tool.wordcount)) input=$(location \(r.src)) $@"
			out:        "genrule(\n  name = \"\(name)\",\n    srcs = \(_srcsList),\n  outs = \(_outsList),\n  cmd = \"\"\"\n\(_cmd)\n\"\"\",\n    tools = \(_toolsList),\n)"
		},
	]

	// Render bundle directly
	_rendered_bundle: [
		for name, b in #in.bundle {
			out: "archive_directory(\n  name = \"\(name)\",\n  dir = \"\(b.srcs)\",\n  prefix = \"\(b.prefix)\",\n)"
		},
	]

	// Render info directly
	_rendered_info: [
		for name, inf in #in.info {
			out: "archive_info(\n  name = \"\(name)\",\n  archive = \"\(inf.archive)\",\n)"
		},
	]

	// Render filegroup directly
	_rendered_filegroup: [
		for name, a in #in.filegroup {
			_srcsItems: [for s in a.srcs {"        \"\(s)\",\n"}]
			_srcsList: "[\n" + strings.Join(_srcsItems, "") + "    ]"
			out:       "filegroup(\n  name = \"\(name)\",\n  srcs = \(_srcsList),\n)"
		},
	]

	// Render test directly
	_rendered_test: [
		for name, t in #in.test {
			_srcsItems: ["        \"\(t.src)\",\n"]
			_srcsList: "[\n" + strings.Join(_srcsItems, "") + "    ]"
			_dataItems: [for d in t.data {"        \"\(d)\",\n"}]
			_dataList: "[\n" + strings.Join(_dataItems, "") + "    ]"
			out:       "sh_test(\n  name = \"\(name)\",\n  srcs = \(_srcsList),\n  data = \(_dataList),\n)"
		},
	]

	// Targets that still use the renderer map (non-map-based templates)
	_targets_list: [
		_t_raw,
		_t_norm_group,
	]

	// Rendered targets - combine all rendered outputs
	_rendered: [
		for l in _rendered_load {l.out},
		(_render[_t_raw.kind] & {#in: _t_raw}).out,
		for n in _rendered_norm {n.out},
		(_render[_t_norm_group.kind] & {#in: _t_norm_group}).out,
		for r in _rendered_size_report {r.out},
		for b in _rendered_bundle {b.out},
		for i in _rendered_info {i.out},
		for a in _rendered_filegroup {a.out},
		for t in _rendered_test {t.out},
	]

	// Final BUILD output
	out: """
# auto-generated: bazel.cue

\(strings.Join(_rendered, "\n"))
"""
}
