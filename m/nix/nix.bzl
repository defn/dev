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
        srcs = [
            "flake.json",
            "flake.lock",
            "flake.nix",
        ] + srcs,
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
            flake_store_script,
            flake_config,
        ],
        outs = ["{}_nix_store.tar".format(name)],
        cmd = "$(location //{}:{}) {} $@".format(flake_store_script.package, flake_store_script.name, dir),
        visibility = visibility,
    )

    flake_path_script = Label(":flake_path_script".format(name))

    for c in cmds:
        native.genrule(
            name = "{}_{}".format(name, c),
            srcs = [
                flake_path_script,
                flake_config,
            ],
            outs = ["{}_{}_bin".format(name, c)],
            cmd = "$(location //{}:{}) {} $@ which {}".format(flake_path_script.package, flake_path_script.name, dir, c),
            visibility = visibility,
        )
