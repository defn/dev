{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = ./.;

    url_template = input: "https://github.com/jdx/mise/releases/download/v${input.vendor}/mise-v${input.vendor}-${input.os}-${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 */bin/mise $out/bin/mise
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "x64";
        sha256 = "sha256-Ow/d8M5t4kVOBW3kKHNmSAxH2tqtIhJuU/auiB8ad/s="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-LFWfqyLoRTPj7aDF0qlGflGRWLbNr0MXY+WrNtYf/rE="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-bJkwDU8OtN1CUTggSaWoU+rS/Y6tCXHdneFg5Z/CtjM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-OPe+5NHazDtmgMR+rYPEzysVHU2WTroRt/l9IqbFlmA="; # aarch64-darwin
      };
    };
  };
}
