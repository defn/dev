{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-chamber"; };

    url_template = input: "https://github.com/segmentio/chamber/releases/download/v${input.vendor}/chamber-v${input.vendor}-${input.os}-${input.arch}";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 $src $out/bin/chamber
    '';

    downloads = {
      options = pkg: {
        dontUnpack = true;
      };

      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ALCR/iWf4i0RAU7U1hsK3Ol6B+YrF249OSQdDWa/bIs="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-ALCR/iWf4i0RAU7U1hsK3Ol6B+YrF249OSQdDWa/bIs="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-X1U1DhllELLfDL3rmBq+WmzjwMBmFoQVtJvtU6Rky1s="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-X1U1DhllELLfDL3rmBq+WmzjwMBmFoQVtJvtU6Rky1s="; # aarch64-darwin
      };
    };
  };
}
