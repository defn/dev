"""
"""

load("@rules_shell//shell:sh_binary.bzl", "sh_binary")

def earthly_build(name, image, data, earthly_bin, build_args = [], visibility = None):
    """Something

    Args:
        name: meh
        image: meh
        data: meh
        earthly_bin: meh
        build_args: meh
        visibility: meh

    Returns:
        something
    """
    native.filegroup(
        name = "{}_earthfile".format(name),
        srcs = ["Earthfile"],
        visibility = visibility,
    )

    earthly_build_script = Label(":earthly_build_script")

    native.genrule(
        name = "{}_earthly_build".format(name),
        srcs = [earthly_build_script, earthly_bin, "{}_earthfile".format(name)] + data,
        outs = ["{}_docker_image.tar".format(name)],
        cmd = "$(location //{}:{}) $@ {} $(location {}) $(location {}_earthfile) {} {}".format(
            earthly_build_script.package,
            earthly_build_script.name,
            image,
            earthly_bin,
            name,
            "\"{}\"".format(" ".join(["--build-arg {}".format(ba) for ba in build_args])),
            " ".join(["$(locations {})".format(d) for d in data]),
        ),
        visibility = visibility,
    )

    docker_load_script = Label(":docker_load_script")

    sh_binary(
        name = "{}_docker_load".format(name),
        srcs = [docker_load_script],
        args = [
            "$(location {}_earthly_build)".format(name),
        ],
        data = [
            "{}_earthly_build".format(name),
        ],
        visibility = visibility,
    )

    return [DefaultInfo(files = depset(["{}_docker_image".format(name)]))]
