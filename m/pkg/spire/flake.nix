{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/spiffe/spire/releases/download/v${input.vendor}/spire-${input.vendor}-${input.os}-${input.arch}-musl.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 spire-*/bin/* $out/bin/
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-rFOFPUeBdfFc7Io3V9cWONCCESbA1pWD7UFBOZ4BxJ8="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-JWqMAn6wKMQNJ7jZYgdjkjU3ECF4s6v2mOoSiChWzKQ="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-rFOFPUeBdfFc7Io3V9cWONCCESbA1pWD7UFBOZ4BxJ8="; # x86_64-linux
      };
      "aarch64-darwin" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-JWqMAn6wKMQNJ7jZYgdjkjU3ECF4s6v2mOoSiChWzKQ="; # aarch64-darwin
      };
    };
  };
}
