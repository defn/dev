{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-JPhq6v2nA9Z4YR3lnvAuO7+q9WIkraZN5T4kX7pWXs0="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-Ry8//GJA4Msk8c8xpu0VWR0UVkFhCU6RMfmO13y/Khw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-KoQpe4Zpe+JbDhAzjRb3DmJFU3jk9w9Gw8w+QXdF/ic="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-1wytHEs9jNY88OMyd7gD5p6Mg8xpc/FhnkCHVuMbZZQ="; # aarch64-darwin
      };
    };
  };
}
