package bashel

import (
	"github.com/defn/dev/m/bashel/bazel"
)

(bazel.#BuildGenerator & {#in: {
	load: "@rules_shell//shell:sh_test.bzl": ["sh_test"]
	load: "//bashel/ex-macros:macros.bzl": ["archive_directory", "archive_info"]

	tool: "uppercase": "//bashel/ex-genrule:uppercase_sh"
	tool: "wordcount": "//bashel/ex-genrule:word_count_sh"
	tool: "lib":       "//b/lib:lib_sh"

	raw_file: "app": {
		path:    "raw/app.conf"
		content: "application configuration settings"
	}
	raw_file: "database": {
		path:    "raw/database.conf"
		content: "database connection parameters"
	}
	raw_file: "cache": {
		path:    "raw/cache.conf"
		content: "cache backend configuration"
	}

	normalize: "raw_configs": {
		"normalized/app.conf":      1
		"normalized/database.conf": 2
		"normalized/cache.conf":    3
	}

	size_report: "config_size_report": {
		src: "normalized_app_conf"
		out: "reports/app_size.txt"
	}

	bundle: "production_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "prod-configs"
	}
	bundle: "staging_config_bundle": {
		srcs:   "normalized_configs"
		prefix: "staging-configs"
	}

	info: "production_bundle_info": {
		archive: "production_config_bundle"
	}
	info: "staging_bundle_info": {
		archive: "staging_config_bundle"
	}

	filegroup: "all_outputs": {
		srcs: [
			"config_size_report",
			"normalized_configs",
			"production_bundle_info",
			"production_config_bundle",
			"staging_bundle_info",
			"staging_config_bundle",
		]
	}

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
