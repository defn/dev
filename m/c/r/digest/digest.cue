package r

image_digests: [
    for i, d in cache {
        "\(i) \(d)"
    }
]