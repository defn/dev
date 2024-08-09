{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/openfga/cli/releases/download/v${input.vendor}/fga_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 fga $out/bin/fga
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-jy1KJ3gXAsnqX2Jnr/zL3kDr9h7poBPLc1C2Q79Roh4="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-MuLB2cXt2vehPPDLjB30PvxQ/c6zYi7SmdXdHmDb9GY="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Y8c1WSEt60rfc3xMFs61UCDi8LAyHPnormiR8V+eHKs="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-Y8c1WSEt60rfc3xMFs61UCDi8LAyHPnormiR8V+eHKs="; # aarch64-darwin
      };
    };
  };
}
