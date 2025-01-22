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
        sha256 = "sha256-eI6ta1GhpjrAC3QIql+ILOgEAPY0BM1i2n1pzvBn5HQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-ApEbrHHyDdlaloyYy4U7B61IO0gJu1fCicJf7/2XUBk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-DIH37JfkbYAqmO+K6QBrYdoUX5r4Q0T1oPX5XkvPZTQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-vY1YgPNBwxINCBl2eU3N5r8F9IXbCXZ1iTD7P7AO3Fw="; # aarch64-darwin
      };
    };
  };
}
