{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buf"; };

    url_template = input: "https://github.com/bufbuild/buf/releases/download/v${input.vendor}/buf-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buf/bin/buf $out/bin/buf
    '';

    downloads = {


      "x86_64-linux" = {
        os = "Linux";
        arch = "x86_64";
        sha256 = "sha256-PpqXtR4PmY/6OIrD+P9QhQGH9KfKCI4feDPPaB6/A6s="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-xGFd6dXOBfIwpcwHr16JX7p5HyS0lxbZXjSNeRYWoTY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-BxRGlEK3NgOtFe5CmcEO1tSHYrFsnDJRZFTvXU4ydy0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-bfQyAKkLpnjh4DwcKz8POUTfdGJzOKQ6FPaB2P0iIXk="; # aarch64-darwin
      };
    };
  };
}
