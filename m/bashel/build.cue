package buildclient

import (
	"strings"

	"github.com/defn/dev/m/bashel/bazel"
)

// --------------- Concrete high-level instance --------------------

m: #Model & {
	loads: [
		{bzl: "@rules_shell//shell:sh_test.bzl", symbols: ["sh_test"]},
		{bzl: "//bashel/ex-macros:macros.bzl", symbols: ["archive_directory", "archive_info"]},
	]

	tools: {
		uppercase: "//bashel/ex-genrule:uppercase_sh"
		wordcount: "//bashel/ex-genrule:word_count_sh"
		lib:       "//b/lib:lib_sh"
	}

	rawFiles: [
		{name: "app", path: "raw/app.conf", content: "application configuration settings"},
		{name: "database", path: "raw/database.conf", content: "database connection parameters"},
		{name: "cache", path: "raw/cache.conf", content: "cache backend configuration"},
	]

	normalize: [
		{from: ":raw_configs", index: 1, out: "normalized/app.conf"},
		{from: ":raw_configs", index: 2, out: "normalized/database.conf"},
		{from: ":raw_configs", index: 3, out: "normalized/cache.conf"},
	]

	sizeReports: [
		{
			name: "config_size_report"
			src:  ":normalized_app_conf"
			out:  "reports/app_size.txt"
		},
	]

	bundles: [
		{name: "production_config_bundle", srcs: ":normalized_configs", prefix: "prod-configs"},
		{name: "staging_config_bundle", srcs: ":normalized_configs", prefix: "staging-configs"},
	]

	infos: [
		{name: "production_bundle_info", archive: ":production_config_bundle"},
		{name: "staging_bundle_info", archive: ":staging_config_bundle"},
	]

	all: {
		name: "all_outputs"
		srcs: [
			":config_size_report",
			":normalized_configs",
			":production_bundle_info",
			":production_config_bundle",
			":staging_bundle_info",
			":staging_config_bundle",
		]
	}

	test: {
		name: "test"
		src:  "test.sh"
		data: [
			":all_outputs",
			"//bashel/ex-genrule:uppercase_sh",
			"//bashel/ex-genrule:word_count_sh",
			"//bashel/ex-macros:create_archive_sh",
			"//bashel/ex-macros:list_archive_sh",
		]
	}
}

#Model: {
	tools: {
		uppercase: bazel.#Label
		wordcount: bazel.#Label
		lib:       bazel.#Label
	}

	loads: [...{
		bzl: string
		symbols: [...string]
	}]

	rawFiles: [...bazel.#CfgFile]

	normalize: [...bazel.#NormalizeStep]

	sizeReports: [...{
		name: string
		src:  bazel.#Label
		out:  string
	}]

	bundles: [...bazel.#Bundle]
	infos: [...bazel.#Info]

	all: {
		name: string
		srcs: [...bazel.#Label]
	}

	test: {
		name: string
		src:  string
		data: [...bazel.#Label]
	}
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

t_test: {
	kind: "sh_test"
	name: m.test.name
	srcs: [m.test.src]
	data: m.test.data
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
	t_test,
]

// ----------------- Renderers ------------------

_render: {
	"load":                    bazel.renderLoad
	"genrule":                 bazel.renderGenrule
	"filegroup":               bazel.renderFilegroup
	"macro.archive_directory": bazel.renderArchiveDir
	"macro.archive_info":      bazel.renderArchiveInfo
	"sh_test":                 bazel.renderShTest
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
