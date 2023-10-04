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
        sha256 = "sha256-JyDWKXzimt4biWJu0hEeggty7j1YFyV5/QFX8QQxoTU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-40ftwFkTdMCHg2Cdc6uuQuZ7pF6kvcsjw0NPGri1fUw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-6d8AZbVEVfjogGFzFoVfVK/PYTZv+GO/Kmu8TRGB8+0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-apUfpFUgc+GCvEJvUXuQA+4rFuX6WrWTu34e9523qEw="; # aarch64-darwin
      };
    };
  };
}
