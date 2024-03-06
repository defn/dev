{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cilium"; };

    url_template = input: "https://github.com/cilium/cilium-cli/releases/download/v${input.vendor}/cilium-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cilium $out/bin/cilium
    '';

    downloads = {
      options = pkg: {
        dontFixup = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-2phnX5YYM9T/1osQRtkHsiin05Te0qvXClCyDqyhccQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-/ha81Ef8b+dkynVxL1gy11BIRen3gmhP8JyfUlSCN/4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-8LP+V2yzrP8weYRraSVyCZ7uKHt1zf+qRB92ZcGK1O8="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-6hXgLLPdFG0PPPCwAKNH6t8kNrJ5qbUW3Yd82s9LgQw="; # aarch64-darwin
      };
    };
  };
}
