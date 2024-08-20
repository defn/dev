{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-dapr"; };

    url_template = input: "https://github.com/dapr/cli/releases/download/v${input.vendor}/dapr_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 dapr $out/bin/dapr
    '';

    downloads = {


      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-IVBliOkm3emGrmGVV/Q8YUKy4Zd0/egNdKkvDTXSwnY="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-p4kJjf6YikG8jICAdC3jApBBKrNm3iCxZdE9XUOyDp8="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-arfTTnkFvw9WKvXMBkGyCbnlMoMB5u9FD3ACtF/f+ys="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-dDMflcnxNVux6/OBsJahsTbypd1cvK2zBIIGM+RaWP0="; # aarch64-darwin
      };
    };
  };
}
