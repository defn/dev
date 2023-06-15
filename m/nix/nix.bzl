"""
"""

def nix_flake(name, visibility = None, flakes = []):
    native.filegroup(
        name = "{}_config".format(name),
        srcs = [
            "flake.json",
            "flake.lock",
            "flake.nix",
        ],
    )

    native.genrule(
        name = "{}_archives".format(name),
        srcs = [
            Label(":flake_store_script"),
            "{}_config".format(name),
        ],
        outs = ["{}_nix_stores".format(name)],
        cmd = "$(location //nix:flake_store_script) $@",
        visibility = visibility,
    )

    for f in flakes:
        native.genrule(
            name = "{}_{}".format(name, f),
            srcs = [
                Label(":flake_path_script".format(name)),
                "{}_config".format(name),
            ],
            outs = ["{}_{}_bin".format(name, f)],
            cmd = "$(location //nix:flake_path_script) $@ which {}".format(f),
            visibility = visibility,
        )
