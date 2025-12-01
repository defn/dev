package bashel

import (
	"github.com/defn/dev/m/bashel/bazel"
)

(bazel.#BuildGenerator & {#in: {
	// load()
	load: "@rules_shell//shell:sh_test.bzl": ["sh_test"]
	load: "//bashel/ex-macros:macros.bzl": ["archive_directory", "archive_info"]

	// tool references (used by genrules)
	tool: "uppercase": "//bashel/ex-genrule:uppercase_sh"
	tool: "wordcount": "//bashel/ex-genrule:word_count_sh"
	tool: "lib":       "//b/lib:lib_sh"

	//////////////////////////////////////////////////////////////////
	// inputs
	//

	// [*] -> raw_configs
	raw_config: "app": {
		path:    "raw/app.conf"
		content: "application configuration settings"
	}
	raw_config: "database": {
		path:    "raw/database.conf"
		content: "database connection parameters"
	}
	raw_config: "cache": {
		path:    "raw/cache.conf"
		content: "cache backend configuration"
	}

	//////////////////////////////////////////////////////////////////
	// outputs
	//

	// raw_configs -> normalized_configs, [ normalized_*_conf ]
	normalize: "raw_configs": {
		"normalized/app.conf":      1
		"normalized/database.conf": 2
		"normalized/cache.conf":    3
	}

	// normalized_app_conf → size_report_app_conf
	size_report: "size_report_app_conf": {
		src: "normalized_app_conf"
		out: "reports/app_size.txt"
	}

	// normalized_configs -> [ bundle ]
	bundle: "production_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "prod-configs"
	}
	bundle: "staging_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "staging-configs"
	}

	// [ bundle ] -> [ info ]
	info: "production_bundle_info": {
		archive: "production_config_bundle"
	}
	info: "staging_bundle_info": {
		archive: "staging_config_bundle"
	}

	//////////////////////////////////////////////////////////////////
	// tests
	//

	// [*] -> all_outputs
	filegroup: "all_outputs": {
		srcs: [
			"normalized_configs",
			"size_report_app_conf",
			"production_bundle_info",
			"production_config_bundle",
			"staging_bundle_info",
			"staging_config_bundle",
		]
	}

	// all_outputs -> test_sh
	test: "test_sh": {
		src: "test.sh"
		data: [
			"all_outputs",
			"//bashel/bazel:bazel_cue",
			"//bashel/ex-genrule:uppercase_sh",
			"//bashel/ex-genrule:word_count_sh",
			"//bashel/ex-macros:create_archive_sh",
			"//bashel/ex-macros:list_archive_sh",
		]
	}
}}).out
