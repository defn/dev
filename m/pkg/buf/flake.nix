{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.11?dir=m/pkg/pkg;
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
        sha256 = "sha256-AAFZn+mv6MgmuMm+Pn2ebDEXIjUXGduuzQUMtl8xs58="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "Linux";
        arch = "aarch64";
        sha256 = "sha256-V4Lb+rmGvnXOboHGtYVZo0yTwmXbgdWmbZ2qJSNJEGE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "Darwin";
        arch = "x86_64";
        sha256 = "sha256-zVienuBWsprljtKULU5hBfZFqoufd4xZfqJFb9KCLrA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "Darwin";
        arch = "arm64";
        sha256 = "sha256-cku6hGf6OlQwj8j+8L6BMxK+pZ9C+5fLPG/7aNBIb74="; # aarch64-darwin
      };
    };
  };
}
