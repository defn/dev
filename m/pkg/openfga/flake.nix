{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
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
        sha256 = "sha256-rjfu+SU63rysse/8etOUDITn9D9IXyYVm8VwbFrPCWU="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-+v4v9lig8Mn+v4M2cmOhKn4mjssX7JA6OGdcczdB1jA="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sIATkzy09gvQcspvtNsvgsjcz1uhqHhQeRGNPjJLe1c="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-sIATkzy09gvQcspvtNsvgsjcz1uhqHhQeRGNPjJLe1c="; # aarch64-darwin
      };
    };
  };
}
