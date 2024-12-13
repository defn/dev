{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-regctl"; };

    url_template = input: "https://github.com/regclient/regclient/releases/download/v${input.vendor}/regctl-${input.os}-${input.arch}";

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Inbt7loeXLibtORI5dAjVkrNbYSlQZzJL/Ji2F37jpo="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-6cXL+dpQUoQgkcNiG0k+piHw/+G3KqdrYLa1/haquN4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-RHuyX4G1Sk1plj0spLmK476+Jljk/fqh3oOAvCzCwuw="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-jUzYxiyhtoeh4clFm8kdLfkzmHkk65+YksB/eBJAqJU="; # aarch64-darwin
      };
    };

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/regctl
    '';
  };
}
