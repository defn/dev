"""
"""

load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def copy_outputs(name, gen, visibility = None):
    """Something

    Args:
        name: something
        gen: meh
        visibility: something

    Returns:
        something

    https://www.aspect.dev/blog/bazel-can-write-to-the-source-folder
    """
    _GENERATED = {
        "{}/{}".format(native.package_name(),k): "//{}:{}".format(native.package_name(),v)
        for [k, v] in gen.items()
    }

    for [k, v] in gen.items():
        diff_test(
            name = "check_" + k,
            failure_message = "Please run: b run //{}:update_repo".format(native.package_name()),
            file1 = k,
            file2 = v,
            visibility = visibility,
        )

    write_file(
        name = "gen_update_script",
        out = "update.sh",
        content = [
            "#!/usr/bin/env bash",
            "cd $BUILD_WORKSPACE_DIRECTORY",
        ] + [
            "cp -fv bazel-bin/{1} {0}; chmod 644 {0}".format(
                k,
                # Convert label to path
                v.replace(":", "/"),
            )
            for [k, v] in _GENERATED.items()
        ],
        visibility = visibility,
    )

    native.sh_binary(
        name = "update__repo",
        srcs = ["update.sh"],
        data = _GENERATED.values(),
        visibility = visibility,
    )