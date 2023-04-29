{
  inputs.pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
        sha256 = "sha256-xXysiM/4l2svi3vYCgD1l0oKmTnVXZbhQDG6o00lHNk="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Up/zg358tMloVTTk//vRc7CtdBDSzhSe8e6+P2YOpLQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Bg+9yvXMTUrVNLFP20isqbjkvs5iMBvzRTfANLPXMTI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-20nTSU/lfAs4jPWN7mLyzt5avjZXhB1PO8g/VGrzHxM="; # aarch64-darwin
      };
    };
  };
}
