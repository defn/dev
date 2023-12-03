"""
"""

load("@bazel_skylib//rules:write_file.bzl", "write_file")

def copy_files(name, gen, dir = None, prefix = None, visibility = None):
    """Something

    Args:
        name: something
        gen: something
        dir: something
        prefix: somethng
        visibility: something

    Returns:
        something

    https://www.aspect.dev/blog/bazel-can-write-to-the-source-folder
    """
    _GENERATED = {
        "{}/{}".format(native.package_name(), k): "//{}:{}".format(native.package_name(), v)
        for [k, v] in gen.items()
    }

    write_file(
        name = "{}_gen_script".format(name),
        out = "{}_update.sh".format(name),
        content = [
            "#!/usr/bin/env bash",
            "cd $BUILD_WORKSPACE_DIRECTORY",
        ] + [
            "set -x; exec 2>>/tmp/meh.log; echo {1}; if test -d bazel-bin/{1}; then rsync -ia bazel-bin/{1}/* {2}/ >/dev/null; else mkdir -p $(dirname {3}); install -m 0644 bazel-bin/{1} {3}; fi".format(
                k,
                # Convert label to path
                v.replace(":", "/"),
                dir,
                k if prefix == None else prefix,
            )
            for [k, v] in _GENERATED.items()
        ],
        visibility = visibility,
    )

    native.sh_binary(
        name = "{}__update".format(name),
        srcs = ["{}_update.sh".format(name)],
        data = _GENERATED.values(),
        visibility = visibility,
    )
