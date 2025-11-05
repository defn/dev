"""Build macros for config bundling"""

def bundle_configs(name, config_dir, env = "production", visibility = None):
    """Bundles configuration files for an environment.

    Args:
        name: Name of the bundle target
        config_dir: Directory containing config files
        env: Environment name (production, development, etc.)
        visibility: Target visibility
    """
    script = Label("//b/ex-build:bundle_configs_sh")

    native.genrule(
        name = name,
        tools = [
            script,
            "//b/lib:lib_sh",
        ],
        srcs = [config_dir],
        outs = ["{}.tar.gz".format(name)],
        cmd = "$(location {}) env={} $@ $(locations {})".format(
            script,
            env,
            config_dir,
        ),
        visibility = visibility,
    )

def bundle_info(name, bundle, visibility = None):
    """Extracts information from a config bundle.

    Args:
        name: Name of the info target
        bundle: Bundle archive to inspect
        visibility: Target visibility
    """
    script = Label("//b/ex-build:extract_bundle_info_sh")

    native.genrule(
        name = name,
        tools = [
            script,
            "//b/lib:lib_sh",
        ],
        srcs = [bundle],
        outs = ["{}.txt".format(name)],
        cmd = "$(location {}) bundle=$(location {}) $@".format(
            script,
            bundle,
        ),
        visibility = visibility,
    )
