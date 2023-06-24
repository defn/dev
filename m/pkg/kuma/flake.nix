{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://download.konghq.com/kuma-binaries-release/kuma-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      ls -ltrhd kuma*/bin/*
      install -m 0755 kuma*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-t4QwKZrQyZI1HsuWoHNQ6enxwPvVtKf/PgSOFiWa0ZE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-RDtBSDc8thU9skTWtNX6tk6GzT04MX0b7UeAAEpAcTM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-nRqu4mtR1gyyYJTdlSYSEzdv4LGce7pbHbDv6P81J+0="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-lvSXePZNat++ylC/Q+mjxzCH66YPUhiLu/YxJlvg5l0="; # aarch64-darwin
      };
    };
  };
}
