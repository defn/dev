"""
"""

def earthly_build(name, image, data, earthly_bin, visibility = None):
    native.filegroup(
        name = "{}_earthfile".format(name),
        srcs = [
            "Earthfile",
        ],
        visibility = visibility,
    )

    earthly_build_script = Label(":earthly_build_script")

    native.genrule(
        name = "{}_earthly_build".format(name),
        srcs = [earthly_build_script, earthly_bin, "{}_earthfile".format(name)] + data,
        outs = ["{}_docker_image".format(name)],
        cmd = "$(location //{}:{}) $@ {} $(location {}) $(location {}_earthfile) {}".format(
            earthly_build_script.package,
            earthly_build_script.name,
            image,
            earthly_bin,
            name,
            " ".join(["$(location {})".format(d) for d in data]),
        ),
    )

    return [DefaultInfo(files = depset(["{}_docker_image".format(name)]))]
