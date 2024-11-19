{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-temporal"; };

    url_template = input: "https://github.com/temporalio/cli/releases/download/v${input.vendor}/temporal_cli_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 temporal $out/bin/temporal
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-SBwrwgWUTp3kQd1Rv3Jiw1mNIyqb7XKRJaG07nn/6wE="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-q5RVtSrya3D9fgaVN40Xe0eGs7j9DUx52h3GpLiufKw="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-7uteKkjl1Oy1TdV4O32IA+gEz1LfDLk21rAa03TzjBQ="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-CDxjdEI0aOlBUAId6cg4Nwk16qgpXrW/Kl9yduj1zus="; # aarch64-darwin
      };
    };
  };
}
