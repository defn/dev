"""
"""

def nix_flake(name, srcs = [], cmds = [], flake = None, visibility = None):
    """ something

    Args:
        name: something
        srcs: something
        visibility: something
        flake: something
        cmds: something
    """
    dir = native.package_name()

    native.filegroup(
        name = "{}_config".format(name),
        srcs = srcs + [
            "flake.json",
            "flake.lock",
            "flake.nix",
        ],
        visibility = visibility,
    )

    if flake == None:
        flake_config = "{}_config".format(name)
    else:
        flake_config = flake

    flake_store_script = Label(":flake_store_script")

    native.genrule(
        name = "{}_store".format(name),
        srcs = [
            flake_config,
        ],
        tools = [
            flake_store_script,
            "//b/lib:lib_sh",
        ],
        outs = ["{}_nix_store.tar".format(name)],
        cmd = "$(location //{}:{}) dir={} $@".format(flake_store_script.package, flake_store_script.name, dir),
        visibility = visibility,
    )

    flake_which_script = Label(":flake_which_script".format(name))

    for c in cmds:
        native.genrule(
            name = "{}_{}".format(name, c),
            srcs = [
                flake_config,
            ],
            tools = [
                flake_which_script,
                "//b/lib:lib_sh",
            ],
            outs = ["{}_{}_bin".format(name, c)],
            cmd = "$(location //{}:{}) dir={} $@ which {}".format(flake_which_script.package, flake_which_script.name, dir, c),
            visibility = visibility,
        )

    flake_path_script = Label(":flake_path_script".format(name))

    native.genrule(
        name = "{}_path".format(name),
        srcs = [
            "{}_store".format(name),
            flake_config,
        ],
        tools = [
            flake_path_script,
            "//b/lib:lib_sh",
        ],
        outs = ["{}_path.tar.gz".format(name)],
        cmd = "$(location //{}:{}) dir={} $@".format(flake_path_script.package, flake_path_script.name, dir),
        visibility = visibility,
    )
