"""
"""

load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def copy_files(name, gen, dir = None, visibility = None):
    """Something

    Args:
        name: something
        gen: something
        dir: something
        visibility: something

    Returns:
        something

    https://www.aspect.dev/blog/bazel-can-write-to-the-source-folder
    """
    _GENERATED = {
        "{}/{}".format(native.package_name(),k): "//{}:{}".format(native.package_name(),v)
        for [k, v] in gen.items()
    }

    if dir != None:
        for [k, v] in gen.items():
            diff_test(
                name = "{}_check_".format(name) + k,
                failure_message = "Please run: b run //{}:update_repo".format(native.package_name()),
                file1 = k,
                file2 = v,
                visibility = visibility,
            )

    write_file(
        name = "{}_gen_script".format(name),
        out = "{}_update.sh".format(name),
        content = [
            "#!/usr/bin/env bash",
            "cd $BUILD_WORKSPACE_DIRECTORY",
        ] + [
            "set -x; if test -d bazel-bin/{1}; then rsync -ia bazel-bin/{1}/* {2}/; else mkdir -p $(dirname {0}); mv -f bazel-bin/{1} {0}; fi".format(
                k,
                # Convert label to path
                v.replace(":", "/"),
                dir,
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