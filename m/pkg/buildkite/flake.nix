{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-buildkite"; };

    url_template = input: "https://github.com/buildkite/agent/releases/download/v${input.vendor}/buildkite-agent-${input.os}-${input.arch}-${input.vendor}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 buildkite-agent $out/bin/buildkite-agent
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-8rR12OP1bJswd3MSt64/8w0y4Rhf8cC9MrQDfQLNixQ="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-Hsh429WTFvmNuhqXtqnNg+8GG2B1Yz/zNEVjYliImvM="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-rkbo/TGc22UZm++Lj96l+K5kd5PXlhbvmQ4EddrJ9Yk="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64"; # no arm64 macos
        sha256 = "sha256-rkbo/TGc22UZm++Lj96l+K5kd5PXlhbvmQ4EddrJ9Yk="; # aarch64-darwin
      };
    };
  };
}
