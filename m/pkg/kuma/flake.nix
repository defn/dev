{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://packages.konghq.com/public/kuma-binaries-release/raw/names/kuma-${input.os}-${input.arch}/versions/${input.vendor}/kuma-${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      ls -ltrhd kuma*/bin/*
      install -m 0755 kuma*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-HexvMps6p010LcrJ0tlSRJGZzegztwwQlpCL7UgRR/M="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-9tRKIhEChK7XPvRMn3iQCekMSUCP+rhi3/sqlJ6OKXM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-OddpONQUHfVOlga2Lm65K0JJAWSKFmW1lGVBqlPNPeI="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-dYEG6sCZxJ7NFlAi4Aq4/C7/8VMp/I0q78uPCPggZt4="; # aarch64-darwin
      };
    };
  };
}
