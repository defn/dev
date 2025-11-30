// bazel.cue
// Bazel build generation engine: schemas, renderers, and transformation logic

package bazel

import ( "strings"

	// ---------------- Schema (abstract, not 1:1 Bazel) ----------------
)

#Label: string & =~"^(:|//).+" // Bazel-ish labels

#CfgFile: {
	name:    string // logical name
	path:    string // relative output path under raw/ or normalized/
	content: string // inline content to seed a raw genrule
}

#NormalizeStep: {
	// select from a multi-out raw genrule by positional index (1-based for $$N)
	from:  #Label // e.g. ":raw_configs"
	index: int & >0
	out:   string // e.g. "normalized/app.conf"
}

#Bundle: {
	name:                      string
	srcs: #Label | [...#Label] // often a filegroup
	prefix:                    string
}

#Info: {
	name:    string
	archive: #Label
}

#Model: {
	tools: {
		uppercase: #Label
		wordcount: #Label
		lib:       #Label
	}

	loads: [...{
		bzl: string
		symbols: [...string]
	}]

	rawFiles: [...#CfgFile]

	normalize: [...#NormalizeStep]

	sizeReports: [...{
		name: string
		src:  #Label
		out:  string
	}]

	bundles: [...#Bundle]
	infos: [...#Info]

	all: {
		name: string
		srcs: [...#Label]
	}

	test: {
		name: string
		src:  string
		data: [...#Label]
	}
}

// ----------------- Renderers ------------------

#q: {
	#in: string
	out: "\"\(#in)\""
}

renderLoad: {
	#in: {
		bzl: string
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

#BuildGenerator: {
	#in: #Model

	// Renderer map
	_render: {
		"load":                    renderLoad
		"genrule":                 renderGenrule
		"filegroup":               renderFilegroup
		"macro.archive_directory": renderArchiveDir
		"macro.archive_info":      renderArchiveInfo
		"sh_test":                 renderShTest
	}

	// Templates
	_t_loads: [
		for l in #in.loads {
			kind: "load"
			l
		},
	]

	_t_raw: {
		kind: "genrule"
		name: "raw_configs"
		outs: [for f in #in.rawFiles {f.path}]
		_echos: [for f in #in.rawFiles {"echo '\(f.content)' > $(@D)/\(f.path)"}]
		_echosJoined: strings.Join(_echos, "\n")
		cmd:          """
mkdir -p $(@D)/raw
\(_echosJoined)
"""
	}

	_t_norm: [
		for i, n in #in.normalize {
			{
				kind: "genrule"
				name: "normalized_\(#in.rawFiles[i].name)_conf"
				srcs: [n.from]
				outs: [n.out]
				cmd: """
set -- $(locations \(n.from))
$(location \(#in.tools.uppercase)) input=$$\(n.index) $@
"""
				tools: [#in.tools.uppercase, #in.tools.lib]
			}
		},
	]

	_t_norm_group: {
		kind: "filegroup"
		name: "normalized_configs"
		srcs: [
			for r in _t_norm {":\(r.name)"},
		]
	}

	_t_reports: [
		for r in #in.sizeReports {
			{
				kind: "genrule"
				name: r.name
				srcs: [r.src]
				outs: [r.out]
				cmd: "$(location \(#in.tools.wordcount)) input=$(location \(r.src)) $@"
				tools: [#in.tools.wordcount, #in.tools.lib]
			}
		},
	]

	_t_bundles: [
		for b in #in.bundles {
			{
				kind:   "macro.archive_directory"
				name:   b.name
				dir:    b.srcs
				prefix: b.prefix
			}
		},
	]

	_t_infos: [
		for inf in #in.infos {
			{
				kind:    "macro.archive_info"
				name:    inf.name
				archive: inf.archive
			}
		},
	]

	_t_all: {
		kind: "filegroup"
		name: #in.all.name
		srcs: #in.all.srcs
	}

	_t_test: {
		kind: "sh_test"
		name: #in.test.name
		srcs: [#in.test.src]
		data: #in.test.data
	}

	// Targets list
	_targets_list: [
		for x in _t_loads {x},
		_t_raw,
		for x in _t_norm {x},
		_t_norm_group,
		for x in _t_reports {x},
		for x in _t_bundles {x},
		for x in _t_infos {x},
		_t_all,
		_t_test,
	]

	// Rendered targets
	_rendered: [
		for t in _targets_list {
			(_render[t.kind] & {#in: t}).out
		},
	]

	// Final BUILD output
	out: """
# auto-generated: bazel.cue

\(strings.Join(_rendered, "\n"))
"""
}
