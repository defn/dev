"""
"""

def earthly_build(name, data, earthly_bin, visibility = None):
    native.filegroup(
        name = "{}_earthfile".format(name),
        srcs = [
            "Earthfile",
        ],
        visibility = visibility,
    )

    native.sh_binary(
        name = "{}_earthly_build".format(name),
        srcs = [
            Label("earthly_build"),
        ],
        visibility = visibility,
        args =
            ["$(location {})".format(earthly_bin)] +
            ["$(location {}_earthfile)".format(name)] +
            ["$(location {})".format(d) for d in data],
        data = [earthly_bin, "{}_earthfile".format(name)] + data,
    )
