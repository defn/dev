{
  inputs.pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
  outputs = inputs: inputs.pkg.downloadMain rec {
    src = builtins.path { path = ./.; name = "pkg-vhs"; };

    url_template = input: "https://github.com/nabeken/go-github-apps/releases/download/v${input.vendor}/go-github-apps_${input.vendor}_${input.os}_${input.arch}.tar.gz";

    installPhase = pkg: ''
      install -m 0755 -d $out $out/bin
      install -m 0755 go-github-apps $out/bin/go-github-apps
    '';

    downloads = {
      "x86_64-linux" = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-Xuqo++E1X4zQms5sVCwGPiVaw1b5poTviS6VcUE1J2c="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-OL03beIfxIbe7tFncyNQ1Kty0FmENGUpFX/35g3c9Gg="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-8ddIAP8H+80/TrXiC3NWwuK0JpI/e1fVJCBHyb/R/8E="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-erphlnZN26cNFLNFNjxNNU/4B4dkttI9xVgYKHz67zA="; # aarch64-darwin
      };
    };
  };
}
