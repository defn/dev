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
