// build_client.cue
// High-level model -> normalized Bazel rule set -> rendered BUILD text

package buildclient

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

// ---------------- Templates  ----------------

t_loads: [
	for l in m.loads {
		kind: "load"
		l
	},
]

t_raw: {
	kind: "genrule"
	name: "raw_configs"
	outs: [for f in m.rawFiles {f.path}]
	_echos: [for f in m.rawFiles {"echo '\(f.content)' > $(@D)/\(f.path)"}]
	_echosJoined: strings.Join(_echos, "\n")
	cmd:          """
mkdir -p $(@D)/raw
\(_echosJoined)
"""
}

t_norm: [
	for i, n in m.normalize {
		{
			kind: "genrule"
			name: "normalized_\(m.rawFiles[i].name)_conf"
			srcs: [n.from]
			outs: [n.out]
			cmd: """
set -- $(locations \(n.from))
$(location \(m.tools.uppercase)) input=$$\(n.index) $@
"""
			tools: [m.tools.uppercase, m.tools.lib]
		}
	},
]

t_norm_group: {
	kind: "filegroup"
	name: "normalized_configs"
	srcs: [
		for r in t_norm {":\(r.name)"},
	]
}

t_reports: [
	for r in m.sizeReports {
		{
			kind: "genrule"
			name: r.name
			srcs: [r.src]
			outs: [r.out]
			cmd: "$(location \(m.tools.wordcount)) input=$(location \(r.src)) $@"
			tools: [m.tools.wordcount, m.tools.lib]
		}
	},
]

t_bundles: [
	for b in m.bundles {
		{
			kind:   "macro.archive_directory"
			name:   b.name
			dir:    b.srcs
			prefix: b.prefix
		}
	},
]

t_infos: [
	for inf in m.infos {
		{
			kind:    "macro.archive_info"
			name:    inf.name
			archive: inf.archive
		}
	},
]

t_all: {
	kind: "filegroup"
	name: m.all.name
	srcs: m.all.srcs
}

targets: [
	for x in t_loads {x},
	t_raw,
	for x in t_norm {x},
	t_norm_group,
	for x in t_reports {x},
	for x in t_bundles {x},
	for x in t_infos {x},
	t_all,
]

// ----------------- Renderers ------------------

_render: {
	"load":                    renderLoad
	"genrule":                 renderGenrule
	"filegroup":               renderFilegroup
	"macro.archive_directory": renderArchiveDir
	"macro.archive_info":      renderArchiveInfo
}

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

// ----------------- Rendering to BUILD ------------------

_targets: [
	for t in targets {
		(_render[t.kind] & {#in: t}).out
	},
]

BUILD: """
# auto-generated: bazel.cue

\(strings.Join(_targets, "\n"))
"""
