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
        sha256 = "sha256-CX53DLZNxCY0WWXiO9GbthKZrN8W9lgFQ2YkYQW4dXQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-iBF+MPZ+Ceawe7KD3DzR1PysyfAhsOMkgo89W/fziss="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-Fl2OJZBm+KzkaFCTovHKxtGjTpF6/J9qsg8q/e+jaJA="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-7MAgTWnhqTJtRlvkG3i+ADkDTPaGnj/XzOxA3tFrWoQ="; # aarch64-darwin
      };
    };
  };
}
