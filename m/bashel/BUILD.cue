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

	//
	// inputs
	//

	// genrule: combined into :raw_configs → consumed by normalize
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

	//
	// outputs
	//

	// genrule (one per output) + filegroup (:normalized_configs) → consumed by bundle, size_report
	normalize: "raw_configs": {
		"normalized/app.conf":      1
		"normalized/database.conf": 2
		"normalized/cache.conf":    3
	}

	// genrule: consumes normalized_app_conf → collected by all_outputs
	size_report: "size_report_config": {
		src: "normalized_app_conf"
		out: "reports/app_size.txt"
	}

	// archive_directory: consumes normalized_configs → consumed by info, collected by all_outputs
	bundle: "production_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "prod-configs"
	}
	bundle: "staging_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "staging-configs"
	}

	// archive_info: consumes bundle → collected by all_outputs
	info: "production_bundle_info": {
		archive: "production_config_bundle"
	}
	info: "staging_bundle_info": {
		archive: "staging_config_bundle"
	}

	//
	// tests
	//

	// filegroup: collects all outputs → consumed by test_sh
	filegroup: "all_outputs": {
		srcs: [
			"normalized_configs",
			"size_report_config",
			"production_bundle_info",
			"production_config_bundle",
			"staging_bundle_info",
			"staging_config_bundle",
		]
	}

	// sh_test
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
