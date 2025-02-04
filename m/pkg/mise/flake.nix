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
        sha256 = "sha256-Sv68vYZVOZJD8Xg0g6ScMmfBXapxChgX+c+om7uS7hw="; # x86_64-linux
      };
      "aarch64-linux" = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-WwsY2JZ3G8iphXYkOZImtRHLBKuAQWZMcLlXnxNXKgk="; # aarch64-linux
      };
      "x86_64-darwin" = {
        os = "macos";
        arch = "x64";
        sha256 = "sha256-GIs8bRrg38p8pKyRx8T8Dy84jnYedpDRa9yEBzSdMco="; # x86_64-darwin
      };
      "aarch64-darwin" = {
        os = "macos";
        arch = "arm64";
        sha256 = "sha256-6GPFdYVYMrP1kG09T9Ua3Y0y27UbJyDOVHI3ERG5ri4="; # aarch64-darwin
      };
    };
  };
}
