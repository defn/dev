package buildclient

// --------------- Concrete high-level instance --------------------

m: #Model & {
  loads: [
    { bzl: "//b/ex-macros:macros.bzl", symbols: ["archive_directory", "archive_info"] },
  ]

  tools: {
    uppercase: "//b/ex-genrule:uppercase_sh"
    wordcount: "//b/ex-genrule:word_count_sh"
    lib:       "//b/lib:lib_sh"
  }

  rawFiles: [
    { name: "app",      path: "raw/app.conf",      content: "application configuration settings" },
    { name: "database", path: "raw/database.conf", content: "database connection parameters" },
    { name: "cache",    path: "raw/cache.conf",    content: "cache backend configuration" },
  ]

  normalize: [
    { from: ":raw_configs", index: 1, out: "normalized/app.conf" },
    { from: ":raw_configs", index: 2, out: "normalized/database.conf" },
    { from: ":raw_configs", index: 3, out: "normalized/cache.conf" },
  ]

  sizeReports: [
    {
      name: "config_size_report"
      src:  ":normalized_app_conf"
      out:  "reports/app_size.txt"
    },
  ]

  bundles: [
    { name: "production_config_bundle", srcs: ":normalized_configs", prefix: "prod-configs" },
    { name: "staging_config_bundle",    srcs: ":normalized_configs", prefix: "staging-configs" },
  ]

  infos: [
    { name: "production_bundle_info", archive: ":production_config_bundle" },
    { name: "staging_bundle_info",    archive: ":staging_config_bundle" },
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
}