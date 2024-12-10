load("@rules_shell//shell:sh_binary.bzl", "sh_binary")

"""
"""

def skopeo_copy(name, image, remote_tags, repository, visibility = None):
    """Something

    Args:
        name: meh
        image: meh
        remote_tags: meh
        repository: meh
        visibility: meh

    Returns:
        something
    """
    skopeo_copy_script = Label(":skopeo_copy_script")

    sh_binary(
        name = "{}__skopeo_copy".format(name),
        srcs = [skopeo_copy_script],
        args = [
            "$(location {})".format(image),
            repository,
        ] + remote_tags,
        data = [
            image,
        ],
        visibility = visibility,
    )

    return [DefaultInfo(files = depset(["{}_docker_image".format(name)]))]
