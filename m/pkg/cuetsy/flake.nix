{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-cuetsy"; };

    url_template = input: "https://github.com/grafana/cuetsy/releases/download/v${input.vendor}/cuetsy_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 cuetsy $out/bin/cuetsy
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-05GMdkSUUbEiCE+oscgZTV0nJCQ4Vrn7bY5OEuSmZto="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-eFIFGunizsTrj9Cf+gRciuVEuKMa3VV56dDmzSEOpx4="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-pR0TJtM/C+Pl3VwV5YfEZIpio8axInnA0B6Fu/OnaqM="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-xtLni1kaqkj4o13hv15WqCFRNL5Pgp0WLv/tclSifbY="; # aarch64-darwin
      };
    };
  };
}
